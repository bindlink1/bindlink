class Workstream < ActiveRecord::Base
  belongs_to :agency
  belongs_to :generalagency
  has_many :worksteps

end
