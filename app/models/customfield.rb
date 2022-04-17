class Customfield < ActiveRecord::Base
  belongs_to :agency
  belongs_to :generalagency
  belongs_to :policy
  belongs_to :client
  belongs_to :producingagency
  has_many :customfieldvalues

  attr_accessible :field_name, :field_type, :associated_with, :encrypt
end
