class Agency < ActiveRecord::Base
  has_many :agents
  has_many :clients
  has_many :prospects
  has_many :submissions
  has_many :appointments
  has_many :policies
  has_many :quotingentities, :through => :appointments
  has_many :invoices, :through => :policies
  has_many :notes
  has_many :quotes
  has_many :documents
  has_many :mgas
  has_many :carriers
  has_many :lineofbusinesses
  has_many :fees
  has_many :referers
  has_many :referrals
  has_many :inboundemails
  has_many :statements
  has_many :al3files

  attr_accessible :agency_name, :address_1, :address_2, :city, :state, :zip, :telephone


end
