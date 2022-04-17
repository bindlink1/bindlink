class Prospectpolicy < ActiveRecord::Base
  belongs_to :client

  attr_accessible :carrier, :expiration_date, :note, :coverage_type
end
