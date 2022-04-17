class Compaybatchpreitem < ActiveRecord::Base
  belongs_to :compay_batch
  belongs_to :policy
  belongs_to :producingagency

  def generatebatch(compays, cpb_id)

    compays.each do |cp|
      cpbpi = Compaybatchpreitem.new
      cpbpi.policy_id = cp.id
      cpbpi.compay_batch_id =  cpb_id
      cpbpi.save
    end

  end
end
