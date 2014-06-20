require 'csv'
require 'kconv'

class Record < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :breakdown
  belongs_to :user

  validates :charge, :breakdown_id, :user_id, :published_at, presence: true

  scope :group_by_years, -> { group("date_format(published_at, '%Y')").count }
  scope :group_by_months, -> { group("date_format(published_at, '%Y/%m')").count }

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
end
