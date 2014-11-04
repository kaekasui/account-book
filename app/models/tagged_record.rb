class TaggedRecord < ActiveRecord::Base

  validates :record_id, :tag_id, :user_id, presence: true
end
