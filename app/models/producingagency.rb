class Producingagency < ActiveRecord::Base
  validates :agency_name, :presence => true

  belongs_to :generalagency
  has_many :policies
  has_many :invoices
  has_many :clients
  has_many :namedinsureds
  has_many :submissions
  has_many :cashtransactions
  has_many :returnpremiumbatchitems
  has_many :documents
  has_many :notes

  attr_accessible :agency_name, :address_1, :address_2, :city, :state, :zip, :telephone, :status, :date_appointed, :date_terminated, :name1099, :address1099, :city1099, :state1099, :zip1099, :tax_id, :agency_code, :agency_contact, :agency_fax, :main_agent_license, :main_email, :secondary_emails, :accounting_email

  def documentcount
    Document.new.producerdoccount(self.id)
  end


  def fulladdress
    @fulladdress = "#{self.address_1} #{self.address_2}#{self.city}, #{self.state} #{self.zip} "
  end

  def activepolcount
    Policy.count( :conditions=>["status = ? AND producingagency_id = ?", "Active",self.id])
  end

  def totalpolcount
    Policy.count( :conditions=>["producingagency_id = ?",self.id])
  end


  def activepolicies
    return Policy.where(["producingagency_id = ? AND effective_date <= current_date AND expiration_date >= current_date AND status <> 'Cancelled'", self.id, ]).order("effective_date DESC")
  end


  def activepoliciesregardlessofeffectivedate
    return Policy.where(["producingagency_id = ?", self.id, ]).order("effective_date DESC")
  end


  def activepremium
    clientpolicies =Policy.where(["status = ? AND producingagency_id = ?", "Active",self.id])
    premtotal = 0
    clientpolicies.each do |pols|
      premtotal = premtotal + pols.annualpremium
    end
    premtotal
  end

  def openbalance
    clientpolicies =Policy.where(["status = ? AND producingagency_id = ?", "Active",self.id])
    premtotal = 0
    clientpolicies.each do |pols|
      premtotal = premtotal + pols.policybalance
    end
    premtotal
  end

  def nameandcode
    na = self.agency_name + " | " + self.agency_code
  end

end
