class Clientphoneemail < ActiveRecord::Base
  belongs_to :client
  attr_accessible :contact_value, :contact_type, :note

end
