class Clientaddress < ActiveRecord::Base
  belongs_to :client

  attr_accessible :address_type, :address_1, :address_2, :city, :state, :zip, :note

  def fulladdress

    @fulladdress = "#{self.address_1} #{self.address_2} #{self.city}, #{self.state} #{self.zip} "
  end

  def citystatezip

    @citystatezip = "#{self.city}, #{self.state} #{self.zip}"
  end

  def addressstreetnum

    @fulladdress = "#{self.address_1} #{self.address_2} "
  end
end
