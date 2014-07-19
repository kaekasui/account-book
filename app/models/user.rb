class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_paranoid

  has_many :breakdowns
  has_many :records

  validates :email, length: { maximum: MAX_LONG_TEXT_FIELD_LENGTH }
end
