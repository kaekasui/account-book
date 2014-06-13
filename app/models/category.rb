class Category < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: MAX_LONG_TEXT_FIELD_LENGTH }

  has_many :breakdowns
end
