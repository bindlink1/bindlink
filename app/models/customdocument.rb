class Customdocument < ActiveRecord::Base
	belongs_to :agency
	belongs_to :generalagency
	has_many :customdocumentfields
  has_many :customdocumentfieldrepeats


end
