class Generalagency < ActiveRecord::Base
  has_many :producingagencies
  has_many :agents
  has_many :carriers
  has_many :policies
  has_many :invoices, :through => :policies
  has_many :lineofbusinesses
  has_many :fees
  has_many :notes
  has_many :quotes
  has_many :tasks
  has_many :documents
  has_many :namedinsureds
  has_many :inboundemails
  has_many :customdocuments


  attr_accessible :agency_name, :address_1, :address_2, :city, :state, :zip, :telephone


  def producercount

    count = Producingagency.where("status != 'Inactive' OR status is Null").find_all_by_generalagency_id(self.id).count


  end

  def topproducersbyprem



  end


end
