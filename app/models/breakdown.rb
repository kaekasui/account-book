class Breakdown < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :category
  belongs_to :user
  has_many :records

  validates :name, presence: true
  validates :category_id, :user_id, presence: true
end
