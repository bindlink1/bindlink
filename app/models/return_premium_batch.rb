class ReturnPremiumBatch < ActiveRecord::Base
  has_many :cashtransactions
  has_many :returnpremiumbatchitems
  has_many :returnpremiumbatchpreitems
  accepts_nested_attributes_for :returnpremiumbatchitems

  def createbatch(ga_id)
    returnbatch = ReturnPremiumBatch.new
    returnbatch.status = 'Processing'
    returnbatch.generalagency_id = ga_id
    returnbatch.save
    returnbatch.generateitems
  end

  def generateitems
    Delayed::Job.enqueue Generatereturnlist.new(self.id,self.generalagency_id)

  end

  def getunprocessed(ga_id)
     ReturnPremiumBatch.where("status='Processing' OR status='Ready'").find_all_by_generalagency_id(ga_id)
  end

  def changestatus(newstatus)
    self.status = newstatus
    self.save
  end


  def destroypreitems
    preitems = Returnpremiumbatchpreitem.find_all_by_return_premium_batch_id(self.id)
    preitems.each do |prei|
      prei.destroy
    end
  end
end
