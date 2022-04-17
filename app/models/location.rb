class Location < ActiveRecord::Base
  belongs_to :policy
  has_many :clients

  attr_accessible  :location_nickname, :address_1, :address_2, :city, :state, :zip, :phone, :fax


  def activepolcount
    Client.count( :conditions=>["status = ? AND location_id = ?", "Active",self.id])

  end

  def totalpolcount
    Client.count( :conditions=>["location_id = ?",self.id])

  end


end
