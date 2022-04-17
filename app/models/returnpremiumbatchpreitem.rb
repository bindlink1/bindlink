class Returnpremiumbatchpreitem < ActiveRecord::Base
belongs_to :return_premium_batch
belongs_to :policy
belongs_to :producingagency

def generatebatch(returnpremiums, rpb_id)

  returnpremiums.each do |ret|
    rpbpi = Returnpremiumbatchpreitem.new
    rpbpi.policy_id = ret.id
    rpbpi.return_premium_batch_id = rpb_id
    rpbpi.save
  end

end

end
