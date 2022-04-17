class Submissionthread < ActiveRecord::Base
  belongs_to :conversation
  has_many :submissionposts
end
