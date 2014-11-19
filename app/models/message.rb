class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedback

  def message_type
    if type == "Answer"
      'warning'
    else
      'success'
    end
  end
end
