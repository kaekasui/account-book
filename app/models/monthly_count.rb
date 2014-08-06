class MonthlyCount < ActiveRecord::Base
  belongs_to :user

  scope :year_data, -> (on = Time.now.year) {
    where(year: on)
  }
end
