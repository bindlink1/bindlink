class Compaybatchitem < ActiveRecord::Base
 belongs_to :compay_batch
belongs_to :policy
belongs_to :producingagency
  has_one :cashtransaction

end
