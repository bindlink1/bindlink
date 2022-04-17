class MorningtaskMailer < ActionMailer::Base
  default from: "morningtasks@bindlink.com"

     def morningreminder(email)
        mail(:to => email, :subject => "Bindlink Morning Task Reminders")




     end
end
