class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :omniauthable # :validatable

  acts_as_paranoid
  before_create :set_code

  has_many :categories
  has_many :breakdowns
  has_many :places
  has_many :records
  has_many :monthly_counts
  has_many :feedbacks
  has_one :cancel

  validates :email, presence: true, uniqueness: true, length: { maximum: MAX_LONG_TEXT_FIELD_LENGTH }, if: :email_required?
  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :password, length: { within: 8..128 }, unless: :password_blank?

  private
    def password_blank?
      password.blank?
    end

    def email_required?
      !password.nil? || !password_confirmation.nil?
    end

    def password_required?
      !password.nil? || !password_confirmation.nil?
    end

    def set_code
      self.code = self.code.blank? ? generate_code : self.code
    end

    def generate_code
      code = SecureRandom.urlsafe_base64(8)
      self.class.where(code: code).blank? ? code : generate_code
    end 
end
