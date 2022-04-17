class MarketingcontactMailer < ActionMailer::Base
  default from: "marketing@bindlink.com"

     def contactemail(params)
       puts "I AM HERE"
       @name = params[:name]
       @agencyname = params[:agencyname]
       @phone = params[:phone]
       @email = params[:email]
       @message = params[:message]
        mail(:to => "mdesiato@bindlink.com", :subject => "Marketing Contact Request")




     end
end
