class Referer < ActiveRecord::Base
  belongs_to :agency
  has_many :referrals
  belongs_to :client

def refererfullname
  if !self.referer_name.blank?
    self.referer_name
  else
    self.client.fullname
  end
end


def referralcountclient
  referrals = Referral.find_all_by_referer_id(self.id)
  counttotal = 0

  referrals.each do |ref|
      client = Client.find(ref.client_id)
      if client.client_status != "Prospect"
        counttotal = counttotal + 1
      end
  end
   counttotal
end

def referralcountprospect
  referrals = Referral.find_all_by_referer_id(self.id)
  counttotal = 0

  referrals.each do |ref|
      client = Client.find(ref.client_id)
      if client.client_status == "Prospect"
        counttotal = counttotal + 1
      end
  end
   counttotal
end

def referraltotal
   referrals = Referral.find_all_by_referer_id(self.id)
   premiumtotal = 0

  referrals.each do |ref|
    client = Client.find(ref.client_id)
    premiumtotal = premiumtotal + client.activepremium
  end

  premiumtotal
end



def referraltotalpol
   referrals = Referral.find_all_by_referer_id(self.id)
   policycount = 0

  referrals.each do |ref|
    client = Client.find(ref.client_id)
    policycount = policycount + client.activepolcount
  end

  policycount
end


end
