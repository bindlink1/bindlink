class Appointment < ActiveRecord::Base
  belongs_to :agency
  belongs_to :quotingentity

end
