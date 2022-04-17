class Al3transaction < ActiveRecord::Base
  belongs_to :agency
  belongs_to :policy
  belongs_to :al3h2trg

  def business_purpose_description


    bp = Al3cyclebusinesspurpose.where("code_value = ?", self.cycle_business_purpose)

    bp[0].code_description


  end

  def processtransaction
    @policy = Policy.find(108399)
      ## Additional Premium
    if self.cycle_business_purpose == "PCH" and self.al3h2trg.al3h5bpi.net_change_amount  > 0

      endorse = {:transaction_effective_date => self.al3h2trg.transaction_effective_date.strftime("%m/%d/%Y"), :base_premium => self.al3h2trg.al3h5bpi.net_change_amount.to_s, :fees => "0", :total_premium=>self.al3h2trg.al3h5bpi.net_change_amount.to_s, :endorsetype => "endorse" }

      @policy.endorse(endorse)

    elsif self.cycle_business_purpose == "PCH" and self.al3h2trg.al3h5bpi.net_change_amount  < 0
      endorse = {:transaction_effective_date => self.al3h2trg.transaction_effective_date.strftime("%m/%d/%Y"), :base_premium => (self.al3h2trg.al3h5bpi.net_change_amount * -1).to_s, :fees => "0", :total_premium=> (self.al3h2trg.al3h5bpi.net_change_amount * -1).to_s, :endorsetype => "Return" }
    -
      @policy.endorse(endorse)
      ## Cancel
    elsif  self.cycle_business_purpose == "XLC"
      cancel = {:transaction_effective_date => self.al3h2trg.transaction_effective_date.strftime("%m/%d/%Y"), :base_premium => (self.al3h2trg.al3h5bpi.net_change_amount * -1).to_s, :fees => "0", :total_premium=> (self.al3h2trg.al3h5bpi.net_change_amount * -1).to_s }
     -
       @policy.cancel(cancel, "no")
      ## Reinstate
    elsif  self.cycle_business_purpose == "REI"

      @policy.reinstate(@policy.id)
    end

    self.processed = true

   # self.save




  end

  def processnew
    ## New Business
    if self.cycle_business_purpose == "NBS"

      ## Renew
    elsif  self.cycle_business_purpose == "RWL"

    end
  end

  def matchtransaction

  end
end
