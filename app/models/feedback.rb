# User send some feedbacks.
class Feedback < ActiveRecord::Base
  belongs_to :user

  validates :content, :user_id, presence: true
end
