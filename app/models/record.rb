require 'csv'
require 'kconv'

class Record < ActiveRecord::Base
  attr_accessor :category_type, :tagged
  acts_as_paranoid
  after_commit :count_monthly_records_worker
  belongs_to :category
  belongs_to :breakdown
  belongs_to :user
  has_many :tagged_records
  validates :charge, :category_id, :user_id, :published_at, presence: true

  scope :group_by_years, -> { group("date_format(published_at, '%Y')").count }
  scope :group_by_months, -> { group("date_format(published_at, '%Y/%m')").count }
  scope :total_charge, -> { sum(:charge) }

  def yen_charge
    "¥" + self.charge.to_s
  end

  def csv_import(csv_file)
    text = csv_file.read
    ActiveRecord::Base.transaction do
      line = 0
      CSV.parse(Kconv.toutf8(text)) do |row|
        line = line + 1
        record = Record.new
        record.user_id = self.user_id
        # 日付
        if row[0] =~ /\d\d\d\d-\d\d-\d\d/
          record.published_at = row[0]
        else
          self.errors.add(:published_at, "(#{line}#{I18n.t('labels.line')})" + I18n.t("csv_import.errors.published_at"))
        end
        # 収支
        barance_of_payments = 0
        if row[1].to_i == 0 or row[1].nil?
          barance_of_payments = 0
        elsif row[1].to_i == 1
          barance_of_payments = 1
        else
          self.errors.add(:category_id, "#{I18n.t('csv_import.errors.barance_of_payments_name')}(#{line}#{I18n.t('labels.line')})" + I18n.t("csv_import.errors.barance_of_payments"))
        end
        # カテゴリ
        if row[2].present?
          category = Category.find_by_name(row[2]) || Category.create!(name: row[2], user_id: self.user_id, barance_of_payments: barance_of_payments)
          record.category_id = category.id
        else
          self.errors.add(:category_id, "#{line}#{I18n.t('labels.line')})" + I18n.t("csv_import.errors.empty"))
        end
        # 内訳
        if row[3].present?
          breakdown = category.breakdowns.find_by_name(row[3]) || category.breakdowns.create!(name: row[3], user_id: self.user_id)
          record.breakdown_id = breakdown.id
        end
        # 場所
        if row[4].present?
          place = Place.find_by_name(row[4]) || Place.create!(name: row[4], user_id: self.user_id)
          record.place_id = place.id
        end
        # 料金
        if row[5].blank?
          record.charge = 0
        else
          record.charge = row[5].to_i
        end
        # メモ
        if row[6]
          record.memo = row[6]
        end
        record.save!
      end
    end
    self
  end

  def self.import_csv(csv_file)
    messages = ""
    text = csv_file.read

    CSV.parse(Kconv.toutf8(text)) do |row|
      transaction do
        user = User.find_by_email(row[0]) || User.create(email: row[0], password: "password")
        category = Category.find_by_name(row[1]) || Category.create(name: row[1], user_id: user.id)
        breakdown = Breakdown.find_by_name(row[2]) || Breakdown.create(name: row[2], user_id: user.id, category_id: category.id)
        record = Record.create(published_at: Date.today, breakdown_id: breakdown.id, user_id: user.id, charge: row[3])
        messages = generate_messages(user, category, breakdown, record)
      end
    end
    messages
  end

  def set_records_count
    user = User.find(self.user_id)
    year = self.published_at.year
    month = self.published_at.month
    count = user.records.where("year(published_at) = ? and month(published_at) = ?", year, month).count

    monthly = MonthlyCount.where(year: year, month: month, user_id: user.id).first || MonthlyCount.new(year: year, month: month, user_id: user.id)
    monthly.count = count

    monthly.amount = user.records.total_charge
    monthly.save
  end

  def category_type
    category.nil? ? false : category.barance_of_payments
  end

  def self.sample_format
    [
      [
        I18n.t("csv_import.examples.published_at_1"),
        0,
        I18n.t("csv_import.examples.category_1"),
        I18n.t("csv_import.examples.breakdown_1"),
        I18n.t("csv_import.examples.place_3"),
        8600,
        ""
      ],
      [
        I18n.t("csv_import.examples.published_at_1"),
        0,
        I18n.t("csv_import.examples.category_2"),
        I18n.t("csv_import.examples.breakdown_2"),
        I18n.t("csv_import.examples.place_2"),
        300,
        I18n.t("csv_import.examples.memo_1")
      ],
      [
        I18n.t("csv_import.examples.published_at_1"),
        0,
        I18n.t("csv_import.examples.category_2"),
        I18n.t("csv_import.examples.breakdown_3"),
        I18n.t("csv_import.examples.place_2"),
        500,
        ""
      ],
      [
        I18n.t("csv_import.examples.published_at_2"),
        1,
        I18n.t("csv_import.examples.category_3"),
        "",
        "",
        300000,
        "上期ボーナス"
      ],
      [
        I18n.t("csv_import.examples.published_at_2"),
        0,
        I18n.t("csv_import.examples.category_4"),
        I18n.t("csv_import.examples.breakdown_4"),
        I18n.t("csv_import.examples.place_4"),
        800,
        ""
      ]
    ]
  end

  def self.sample_format_csvfile
    CSV.generate(force_quotes: true) do |csv|
      Record.sample_format.each do |records|
        csv << records
      end
    end
  end

  private

  def self.generate_messages(user, category, breakdown, record)
    errors = []
    errors << "---" + I18n.t("activerecord.attributes.user.email") + ": " + user.email unless user.errors.blank? and category.errors.blank? and breakdown.errors.blank? and record.errors.blank?
    errors.concat user.errors.full_messages unless user.errors.blank?
    errors.concat "カテゴリ" + category.errors.full_messages.to_s unless category.errors.blank?
    errors.concat breakdown.errors.full_messages.to_s unless breakdown.errors.blank?
    errors.concat record.errors.full_messages unless record.errors.blank?
    errors
  end

  def count_monthly_records_worker
    CountMonthlyRecordsWorker.perform_async self.id
  end

end
