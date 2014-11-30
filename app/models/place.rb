# Place is Record's place.
class Place < ActiveRecord::Base
  belongs_to :user
  has_many :records
  validates :name, presence: true, length: { maximum: MAX_TEXT_FIELD_LENGTH }
  validates :user_id, presence: true
end
