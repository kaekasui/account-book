class Category < ActiveRecord::Base
  attr_accessor :submit_type
  acts_as_paranoid
  validates :name, presence: true, length: { maximum: MAX_TEXT_FIELD_LENGTH }

  belongs_to :user
  has_many :breakdowns, dependent: :destroy

  def barance_of_payments_name
    self.barance_of_payments ? I18n.t("category.income") : I18n.t("category.outgo")
  end
end
