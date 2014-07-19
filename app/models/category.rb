class Category < ActiveRecord::Base
  acts_as_paranoid
  validates :name, presence: true, length: { maximum: MAX_TEXT_FIELD_LENGTH }

  has_many :breakdowns, dependent: :destroy
  scope :order_updated_at, -> { order("updated_at DESC") }

  def barance_of_payments_name
    self.barance_of_payments ? I18n.t("category.income") : I18n.t("category.outgo")
  end
end
