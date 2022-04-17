class Fee < ActiveRecord::Base
  belongs_to :agency
  belongs_to :generalagency
  has_many :lineofbusinesses, :through => :lobfees

  has_many :feetransactions

  attr_accessible :fee_name, :fee_type, :state, :fee_value, :fee_remit_type, :earn_type, :attach_type, :effective_date, :expiration_date
end
