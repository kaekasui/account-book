# Answers
class Answer < Message
  belongs_to :feedback

  validates :user_id, :content, presence: true
end
