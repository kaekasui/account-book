# User send some feedbacks.
class Feedback < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :content, :user_id, presence: true
end
