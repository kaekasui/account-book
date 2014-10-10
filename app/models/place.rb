class Place < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: MAX_TEXT_FIELD_LENGTH }
  belongs_to :user
end
