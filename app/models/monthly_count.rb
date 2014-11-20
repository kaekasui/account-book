# User's record monthly's counter.
class MonthlyCount < ActiveRecord::Base
  belongs_to :user

  scope :year_data, lambda(on = Time.now.year) {
    where(year: on)
  }
end
