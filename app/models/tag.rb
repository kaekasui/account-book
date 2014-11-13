class Tag < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  has_many :tagged_records
  validates :name, presence: true, length: { maximum: MAX_TEXT_FIELD_LENGTH }
  validates :user_id, presence: true
  validates :color_code, presence: true, length: { is: 7 }, uniqueness: true
end
