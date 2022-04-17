class Processalert < ActionMailer::Base
  def sendalert(from, email, subject, body)
    mail(:from=>from, :to => email, :subject => subject, :body => body)
  end


  def sendalertsimple( to, subject, body )
    self.sendalert( 'it@granadainsurance.com', to, subject, body ).deliver
  end


  def sendrenewalemail( to, subject, body )
    #body = "<u>This email will be sent to: " + to + " when deployed to production</u><br><br>\n" + body
    #to = "\"Juan Carlos Diaz-Padron\" <jcdp@gicunderwriters.com>,\"Mukul Gupta\" <mgupta@granadainsurance.com>,\"Vladimir Krysanov\" <vkrysanov@sgsdt.com>"
    #to = "\"Vladimir Krysanov\" <vkrysanov@sgsdt.com>"
    from = "\"GIC Underwriters\" <quotes@gicunderwriters.com>"

    mail(:from=>from, :to => to, :subject => subject, :body => body, :content_type => "text/html" ).deliver!
  end


  def sendrenewalreport( subject, body )
    to = "\"Juan Carlos Diaz-Padron\" <jcdp@gicunderwriters.com>,\"Granada IT\" <it@granadainsurance.com>,\"Vladimir Krysanov\" <vkrysanov@sgsdt.com>"
    #to = "\"Vladimir Krysanov\" <vkrysanov@sgsdt.com>"
    from = 'it@granadainsurance.com'

    mail(:from=>from, :to => to, :subject => subject, :body => body, :content_type => "text/html" ).deliver
  end
end
