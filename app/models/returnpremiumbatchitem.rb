class Returnpremiumbatchitem < ActiveRecord::Base
belongs_to :return_premium_batch
belongs_to :policy
belongs_to :pfc
belongs_to :producingagency
belongs_to :client

has_one :cashtransaction

end
