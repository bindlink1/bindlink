class Carriernaic < ActiveRecord::Base
  belongs_to :carrier

  attr_accessible :naic_number, :agency_id
end
