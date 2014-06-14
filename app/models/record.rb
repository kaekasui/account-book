class Record < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :breakdown
  belongs_to :user

  validates :charge, :breakdown_id, :user_id, :published_at, presence: true

  scope :group_by_years, -> { group("date_format(published_at, '%Y')").count }
  scope :group_by_months, -> { group("date_format(published_at, '%Y/%m')").count }
end
