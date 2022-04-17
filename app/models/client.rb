class Client < ActiveRecord::Base
  belongs_to :agent
  has_one :prospect
  belongs_to :location
  belongs_to :producingagency
  has_many :submissions, :dependent => :destroy
  has_many :policies, :dependent => :destroy
  has_many :invoices, :through => :policies
  has_many :notes, :dependent => :destroy
  has_many :clientphoneemails, :dependent => :destroy
  has_many :clientaddresses, :dependent => :destroy
  has_many :clientcontacts, :dependent => :destroy
  has_many :prospectpolicies, :dependent => :destroy
  has_many :customfieldvalues, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :inboundemails, :dependent => :destroy
  has_many :returnpremiumbatchitems
  has_one :referral, :dependent => :destroy
  has_many :acordforminstances, :dependent => :destroy


  attr_accessible :client_name, :address_1, :address2, :city, :state, :zip, :comments, :contactname_1,:contactname_2,:contactname_3,:home_phone, :home_phone_2, :cell_phone, :cell_phone_2, :fax_phone, :email, :mailing_address_1, :mailing_address_2, :mailing_city, :mailing_state, :mailing_zip, :client_type, :first_name, :last_name, :corporate_name, :location_id, :agent_id, :sales_step, :client_source

  def outstandingtaskcount
    count = Task.where("status is null  AND mastertask_id is null AND client_id = ?", self.id).count()

  end

  def completedtaskcount
    count = Task.where("status = 'completed'  AND mastertask_id is null AND client_id = ?", self.id).count()
  end



  def documentcount

    Document.new.clientdoccount(self.id)
  end
  def activepolcount
    Policy.count( :conditions=>["status = ? AND client_id = ?", "Active",self.id])
  end
  def totalpolcount
    Policy.count( :conditions=>["client_id = ?",self.id])
  end
  def cancelledpolcount
    Policy.count( :conditions=>["status = ? AND client_id = ?", "Cancelled",self.id])
  end
  def expiredpolcount
    Policy.count( :conditions=>["status = ? AND client_id = ?", "Expired",self.id])
  end
  def renewedpolcount
    Policy.count( :conditions=>["status = ? AND client_id = ?", "Renewed",self.id])
  end
  def fullname

    if self.client_type == "Individual"
      fullname = "#{self.last_name}, #{self.first_name} "
    else
      fullname = self.corporate_name
    end

  end

  def fulladdress

    @fulladdress = "#{self.address_1} #{self.address2}#{self.city}, #{self.state} #{self.zip} "
  end

  def citystatezip

    @citystatezip = "#{self.city}, #{self.state} #{self.zip}"
  end

  def addressstreetnum

    @fulladdress = "#{self.address_1} #{self.address2} "
  end




  def activepremium
    clientpolicies =Policy.where(["status = ? AND client_id = ?", "Active",self.id])
    premtotal = 0
    clientpolicies.each do |pols|
      premtotal = premtotal + pols.annualpremium
    end
    premtotal
  end

  def openbalance
    clientpolicies =Policy.where(["status = ? AND client_id = ?", "Active",self.id])
    premtotal = 0
    clientpolicies.each do |pols|
      premtotal = premtotal + pols.policybalance
    end
    premtotal
  end

  def convertprospect
    if self.client_status == "Prospect"
      self.client_status = nil
      self.save

    end
  end

end
