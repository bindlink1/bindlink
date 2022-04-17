class MarketingController < ApplicationController

  def features

  end

  def contact

  end
  def index

  end

  def contactform

   MarketingcontactMailer.contactemail(params).deliver


    redirect_to contactthanks_path

  end

  def contactthanks

  end

end
