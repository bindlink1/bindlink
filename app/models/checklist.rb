class Checklist < ActiveRecord::Base
  has_many :checklistitems, :dependent => :destroy
  attr_accessible :checklist_name, :lobcommission_id


end
