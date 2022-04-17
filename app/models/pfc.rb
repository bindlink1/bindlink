class Pfc < ActiveRecord::Base
  belongs_to :agency
  belongs_to :generalagency
  has_many :policies
  has_many :returnpremiumbatchitems
  has_many :cashtransactions
  attr_accessible :pfc_name, :address, :address_2, :city, :state, :zip, :agency_code,:telephone, :marketing_contact, :marketing_telephone, :marketing_email, :contact, :contact_telephone, :contact_email

end
