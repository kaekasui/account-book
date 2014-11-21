require 'csv'
require 'kconv'

# User record.
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
  scope :group_by_months,
        -> { group("date_format(published_at, '%Y/%m')").count }
  scope :total_charge, -> { sum(:charge) }

  def import(file)
    if file.present?
      file_import(file)
    else
      errors[:base] << I18n.t('messages.record.import_file_not_found')
    end
    self
  end

  def file_import(file)
    filename = file.original_filename
    if filename.rindex('.').present? &&
       (filename.slice(filename.rindex('.') + 1,
                       filename.rindex('.') + 3)) == 'csv'
      csv_import(file)
    else
      errors[:base] << I18n.t('messages.record.import_file_is_not_csv')
    end
  end

  def csv_import(csv_file)
    text = csv_file.read
    ActiveRecord::Base.transaction do
      line = 0
      CSV.parse(Kconv.toutf8(text)) do |row|
        line += 1
        record = Record.new
        record.user_id = user_id
        # published_at
        if row[0] =~ /\d\d\d\d-\d\d-\d\d/
          record.published_at = row[0]
        else
          errors.add(:published_at,
                     "(#{line}#{I18n.t('labels.line')})" +
                     I18n.t('csv_import.errors.published_at'))
        end
        # barance_of_payments
        barance_of_payments = 0
        if row[1].to_i == 0 || row[1].nil?
          barance_of_payments = 0
        elsif row[1].to_i == 1
          barance_of_payments = 1
        else
          errors.add(
            :category_id,
            I18n.t('csv_import.errors.barance_of_payments_name') +
            "(#{line}#{I18n.t('labels.line')})" +
            I18n.t('csv_import.errors.barance_of_payments'))
        end
        # category
        if row[2].present?
          category = Category.find_by_name(row[2]) ||
                     Category.create!(
                       name: row[2], user_id: user_id,
                       barance_of_payments: barance_of_payments)
          record.category_id = category.id
        else
          errors.add(:category_id,
                     "(#{line}#{I18n.t('labels.line')})" +
                     I18n.t('csv_import.errors.empty'))
        end
        # breakdown
        if row[3].present?
          breakdown = category.breakdowns.find_by_name(row[3]) ||
                      category.breakdowns.create!(
                        name: row[3], user_id: user_id)
          record.breakdown_id = breakdown.id
        end
        # place
        if row[4].present?
          place = Place.find_by_name(row[4]) ||
                  Place.create!(name: row[4], user_id: user_id)
          record.place_id = place.id
        end
        # charge
        if row[5].blank?
          record.charge = 0
        else
          record.charge = row[5].to_i
        end
        # memo
        record.memo = row[6] if row[6].present?
        record.save!
      end
    end
    self
  end

  def set_records_count
    user = User.find(user_id)
    year, month = published_at.year, published_at.month

    count = user.records.where(
      'year(published_at) = ? and month(published_at) = ?', year, month).count
    set_monthly_records_count(user, count)
  end

  def set_monthly_records_count(user, count)
    monthly = MonthlyCount.where(
                year: year, month: month, user_id: user.id).first ||
              MonthlyCount.new(year: year, month: month, user_id: user.id)
    monthly.update(count: count, amount: user.records.total_charge)
  end

  def category_type
    category.nil? ? false : category.barance_of_payments
  end

  def self.sample_format
    record = []
    CSV.foreach('db/seeds_data/sample_records.csv') do |row|
      record << [row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7]]
    end
    record
  end

  def self.sample_format_csvfile
    CSV.generate(force_quotes: true) do |csv|
      Record.sample_format.each do |records|
        csv << records
      end
    end
  end

  def income
    where(:category, 'barance_of_payments = 0')
  end

  private

  def count_monthly_records_worker
    CountMonthlyRecordsWorker.perform_async id
  end
end
