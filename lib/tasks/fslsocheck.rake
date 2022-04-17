task :fslsocheck => :environment do
  begin
  submission = FslsoAuto.where( "status = 'received'" )

  submission.each do |subm|
    subm.checkSubmissionResponse

    to = 'vkrysanov@sgsdt.com'
    if subm.status != 'received'
      to = 'jcdp@gicunderwriters.com,it@granadainsurance.com,vkrysanov@sgsdt.com'
      to = 'vkrysanov@sgsdt.com'
    end

    subject = "FSLSO Automation status update: #{subm.status} (#{( subm.period_start + 1.minute ).strftime("%m/%d/%Y")} - #{( subm.period_end - 1.minute ).strftime("%m/%d/%Y")}) ##{subm.submissionno}"
    Processalert.sendalertsimple to, subject, subm.message
    #end
  end
  rescue Exception => e
    s = "Caught #{e} exception:
        Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
    to = 'vkrysanov@sgsdt.com'
    subject = "FSLSO Automation status update exception caught"
    Processalert.sendalertsimple to, subject, s
  end
end
