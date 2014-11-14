# TaggedRecord is Record's tags.
class TaggedRecord < ActiveRecord::Base
  belongs_to :record
  belongs_to :tag
  belongs_to :user

  validates :record_id, :tag_id, :user_id, presence: true
end
