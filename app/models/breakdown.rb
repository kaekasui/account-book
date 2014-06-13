class Breakdown < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :category
  belongs_to :user
end
