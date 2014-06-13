class Record < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :breakdown

  validates :charge, :breakdown_id, :published_at, presence: true
end
