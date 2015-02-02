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
  has_many :cancels

  validates :email,
            presence: true,
            length: { maximum: MAX_LONG_TEXT_FIELD_LENGTH },
            if: :email_required?
  validates :email, uniqueness: true, if: :available_email?
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

  def status_code
    if confirmed_at.nil?
      'primary'
    elsif cancel?
      'default'
    else
      'success'
    end
  end

  def status_list
    { '1' => I18n.t('labels.status.primary'),  # 仮登録
      '2' => I18n.t('labels.status.success'),  # 利用中
      '3' => I18n.t('labels.status.default')   # 退会済み
    }
  end

  def cancel?
    status == 3
  end

  private

  def password_blank?
    password.blank?
  end

  def email_required?
    !password.nil? || !password_confirmation.nil?
  end

  def available_email?
    User.where(email: email).where('status = 1 or status = 2').present?
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
