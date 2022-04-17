class Quotingentity < ActiveRecord::Base
  has_many :appointments
  has_many :underwriters
  has_many :agencies, :through => :appointments
  has_many :conversations

end
