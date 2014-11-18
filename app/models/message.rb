class Message < ActiveRecord::Base
  belongs_to :user

  def message_type
    if type == "Answer"
      'warning'
    else
      'success'
    end
  end
end
