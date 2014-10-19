require 'csv'
require 'kconv'

class Record < ActiveRecord::Base
  acts_as_paranoid
  after_commit :count_monthly_records_worker
  belongs_to :category
  belongs_to :breakdown
  belongs_to :user
  validates :charge, :category_id, :user_id, :published_at, presence: true

  scope :group_by_years, -> { group("date_format(published_at, '%Y')").count }
  scope :group_by_months, -> { group("date_format(published_at, '%Y/%m')").count }
  scope :total_charge, -> { sum(:charge) }

  def yen_charge
    "¥" + self.charge.to_s
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
    count = user.records.where("year(published_at) = #{year} and month(published_at) = #{month}").count

    monthly = MonthlyCount.where(year: year, month: month, user_id: user.id).first || MonthlyCount.new(year: year, month: month, user_id: user.id)
    monthly.count = count

    monthly.amount = user.records.total_charge
    monthly.save
  end

  def category_type
    category.nil? ? true : category.barance_of_payments
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
