# User withdraw the side, and then Cancel is its reason.
class Cancel < ActiveRecord::Base
  belongs_to :user

  validates :content, presence: true
end
