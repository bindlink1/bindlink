class Lobcommission < ActiveRecord::Base
  belongs_to :carrierlob
  has_one :checklist
  attr_accessible :state, :commission_rate, :commission_rate_renew,  :producer_rate, :billing_type

  def billingtype

    if self.billing_type == 1
      @billtext = "Agency Bill - Full, Net"
    elsif self.billing_type == 2
      @billtext = "Agency Bill - Full, Gross"
    elsif self.billing_type == 3
      @billtext = "Agency Bill - Premium Finance, Net"
    elsif self.billing_type == 4
      @billtext = "Agency Bill - Premium Finance, Gross"
    elsif self.billing_type == 5
      @billtext = "Direct Bill"
    elsif self.billing_type == 6
      @billtext = "Direct Bill - Full, Gross"
    elsif self.billing_type == 7
      @billtext = "Direct Bill - Installments, Net"
    elsif self.billing_type == 8
      @billtext = "Direct Bill - Installments, Gross"
    elsif self.billing_type == 0
      @billtext = "Agency and Direct Bill (Both)"
    end
  end


  def activepolcount
    Policy.count( :conditions=>["status = ? AND carrier_id = ? AND lineofbusiness_id = ? AND state = ?", "Active",self.carrierlob.carrier.id, self.carrierlob.lineofbusiness_id.to_s, self.state])

  end

  def totalpolcount
    Policy.count( :conditions=>["carrier_id = ? AND lineofbusiness_id = ? AND state = ?",self.carrierlob.carrier.id, self.carrierlob.lineofbusiness_id.to_s, self.state])

  end

  def carriername
    self.carrierlob.carrier.carrier_name
  end

  def namelinestate
    cn = self.carriername
    b = self.carrierlob.lineofbusiness.line_name
   d = self.state

    @nl =  cn  +" - "+ b +" - "+ d
  end

end
