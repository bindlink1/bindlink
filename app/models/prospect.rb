class Prospect < ActiveRecord::Base
  belongs_to :agency
  belongs_to :agent
  belongs_to :generalagency
  belongs_to :producingagency
  belongs_to :client
  has_many :notes
  attr_accessible :prospect_name, :address_1, :address2, :city, :state, :zip, :comments, :contactname_1,:contactname_2,:contactname_3,:home_phone, :home_phone_2, :cell_phone, :cell_phone_2, :fax_phone, :email, :mailing_address_1, :mailing_address_2, :mailing_city, :mailing_state, :mailing_zip, :location_id, :customer_type, :prospect_status, :referral_source


  def converttoclient
      @client = Client.new
      @prospect = Prospect.find(self.id)
      @client.prospect_id = @prospect.id
      @client.client_name = @prospect.prospect_name
      @client.agency_id = @prospect.agency_id
      @client.email = @prospect.email
      @client.contactname_1 = @prospect.contactname_1
      @client.contactname_2 = @prospect.contactname_2
      @client.contactname_3 = @prospect.contactname_3
      @client.home_phone = @prospect.home_phone
      @client.home_phone_2 = @prospect.home_phone_2
      @client.cell_phone = @prospect.cell_phone
      @client.cell_phone_2 = @prospect.cell_phone_2
      @client.agent_id = @prospect.agent_id
      @client.save

  end

end
