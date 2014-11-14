# Original User
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
  has_many :tags
  has_many :tagged_records
  has_one :cancel

  validates :email, presence: true, uniqueness: true, length: { maximum: MAX_LONG_TEXT_FIELD_LENGTH }, if: :email_required?
  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :password, length: { within: 8..128 }, unless: :password_blank?

  def create_data
    categories.create(barance_of_payments: 1, name: '給料')
    category = categories.create(barance_of_payments: 1, name: '臨時収入')
    category.breakdowns.create(name: 'おこづかい', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '食費')
    category.breakdowns.create(name: '外食', user_id: id)
    category.breakdowns.create(name: '食料品', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '日用品')
    category.breakdowns.create(name: '消耗品費', user_id: id)
    category.breakdowns.create(name: '雑貨', user_id: id)
    categories.create(barance_of_payments: 0, name: '衣服')
    category = categories.create(barance_of_payments: 0, name: '水道、光熱費')
    category.breakdowns.create(name: '水道代', user_id: id)
    category.breakdowns.create(name: '電気代', user_id: id)
    category.breakdowns.create(name: 'ガス代', user_id: id)
    categories.create(barance_of_payments: 0, name: '趣味')
    category = categories.create(barance_of_payments: 0, name: '通信費')
    category.breakdowns.create(name: '携帯代', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '美容、健康')
    category.breakdowns.create(name: '化粧品', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '交通費')
    category.breakdowns.create(name: '電車代', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '車、バイク')
    category.breakdowns.create(name: 'ガソリン代', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '教養、教育費')
    category.breakdowns.create(name: '参考書', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '交際費')
    category.breakdowns.create(name: '飲み会会費', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '税金')
    category.breakdowns.create(name: '住民税', user_id: id)
    category = categories.create(barance_of_payments: 0, name: '医療、保険')
    category.breakdowns.create(name: '医療費', user_id: id)
    categories.create(barance_of_payments: 0, name: 'その他')
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
