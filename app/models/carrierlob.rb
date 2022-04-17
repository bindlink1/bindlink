class Carrierlob < ActiveRecord::Base
  belongs_to :carrier
  belongs_to :lineofbusiness

  has_many :lobcommissions
  has_many :policies



  def activepolcount
   Policy.count( :conditions=>["status = ? AND carrier_id = ? AND lineofbusiness_id = ?", "Active",self.carrier.id, self.lineofbusiness_id.to_s])

  end

  def totalpolcount
   Policy.count( :conditions=>["carrier_id = ? AND lineofbusiness_id = ?",self.carrier.id, self.lineofbusiness_id.to_s])

  end

end
