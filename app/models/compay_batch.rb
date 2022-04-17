class CompayBatch < ActiveRecord::Base
  has_many :cashtransactions
  has_many :compaybatchitems
  has_many :compaybatchpreitems , :dependent => :destroy
  accepts_nested_attributes_for :compaybatchitems


  def changestatus(newstatus)
    self.status = newstatus
    self.save
  end

  def destroypreitems
    preitems = Compaybatchpreitem.find_all_by_compay_batch_id(self.id)

    preitems.each do |prei|
      prei.destroy
    end

  end
end
