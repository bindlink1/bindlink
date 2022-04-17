class Carrier < ActiveRecord::Base
  belongs_to :agency
  belongs_to :generalagency
  belongs_to :carrierlob
  has_many :policies
  has_many :carrierlobs
  has_many :lineofbusinesses, :through => :carrierlobs
  has_many :statements
  has_many :statementgroupmembers, :class_name=>"Carrier", :foreign_key => "statementgroup_id"
  has_many :carriernaics

  attr_accessible :carrier_name, :address_1, :address_2, :city, :state, :zip, :commission_percent, :billing_type, :agency_code, :marketing_contact, :marketing_telephone, :marketing_email, :underwriting_contact, :underwriting_telephone, :underwriting_email, :email, :date_appointed, :days_invoice_due, :naic_number, :admitted_status, :isstatementgroup, :statementgroup_id, :status, :web_url

  def activepolcount
    Policy.count( :conditions=>["status = ? AND carrier_id = ?", "Active",self.id])
  end

  def totalpolcount
    Policy.count( :conditions=>["carrier_id = ?",self.id])
  end

  def hasagencybill

    associatedlobs = Carrierlob.find_all_by_carrier_id(self.id)
    hasit = false
    associatedlobs.each do |alob|
      alob.lobcommissions.each do  |lobc|
        if lobc.billing_type == 1
          hasit = true
        end
      end

    end
    hasit

  end

    def hasdirectbillinstallments

    associatedlobs = Carrierlob.find_all_by_carrier_id(self.id)
    hasit = false
    associatedlobs.each do |alob|
      alob.lobcommissions.each do  |lobc|
        if lobc.billing_type == 7
          hasit = true
        end
      end

    end
    hasit

  end

  def associatedlobs
    @associatedlobs = Carrierlob.find_all_by_carrier_id(self.id)
  end

  def nonassociatedlobs(associatedlobs, agentid)
    associated = []

    associatedlobs.each do |alob|
      associated << alob.lineofbusiness_id
    end

    if associated.empty?
      associated << 0
    end

    @agent = Agent.find(agentid)

    if @agent.isgeneralagent == "Retail"
      @alllobs = Lineofbusiness.where('id not in (?)',associated).find_all_by_agency_id(@agent.agency_id)

    else
      @alllobs = Lineofbusiness.where('id not in (?)',associated).find_all_by_generalagency_id(@agent.generalagency_id)
    end

    @alllobs

  end

end
