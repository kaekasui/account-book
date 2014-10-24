class Category < ActiveRecord::Base
  attr_accessor :submit_type
  acts_as_paranoid
  validates :name, presence: true, length: { maximum: MAX_TEXT_FIELD_LENGTH }
  validates :user_id, presence: true

  belongs_to :user
  has_many :breakdowns, dependent: :destroy
  has_many :records

  def barance_of_payments_name
    self.barance_of_payments ? I18n.t("category.income") : I18n.t("category.outgo")
  end
end
