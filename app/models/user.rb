class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  acts_as_paranoid

  has_many :breakdowns
  has_many :records
  has_many :monthly_counts
  has_one :cancel

  validates :email, length: { maximum: MAX_LONG_TEXT_FIELD_LENGTH }
end
