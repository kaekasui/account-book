# Original User
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :omniauthable # :validatable

  acts_as_paranoid
  before_create :set_code

  has_many :messages
  has_many :categories
  has_many :breakdowns
  has_many :places
  has_many :records
  has_many :monthly_counts
  has_many :feedbacks
  has_many :tags
  has_many :tagged_records
  has_one :cancel

  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: MAX_LONG_TEXT_FIELD_LENGTH },
            if: :email_required?
  validates :password,
            presence: true,
            confirmation: true,
            if: :password_required?
  validates :password, length: { within: 8..128 }, unless: :password_blank?

  def create_data
    CSV.foreach('db/seeds_data/categories.csv') do |row|
      categories.create(barance_of_payments: row[0], name: row[1])
    end
    CSV.foreach('db/seeds_data/categoreis.csv') do |row|
      breakdowns.create(category_id: categories.find_by_name(row[0]).id,
                        name: row[1])
    end
  end

  def status
    if confirmed_at.nil?
      'primary'
    elsif cancel?
      'default'
    else
      'success'
    end
  end

  def cancel?
    cancel.present?
  end

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
    self.code = code.blank? ? generate_code : code
  end

  def generate_code
    code = SecureRandom.urlsafe_base64(8)
    self.class.where(code: code).blank? ? code : generate_code
  end
end
