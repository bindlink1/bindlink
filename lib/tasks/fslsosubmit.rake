task :fslsosubmit => :environment do
  begin
  if (1..5).include? Date.today.wday
    start = FslsoAuto.where("success = 't'").maximum("period_end")

    s = ReportsController.new.fslsosubmit( start, Time.now.midnight, false )

    to = 'jcdp@gicunderwriters.com,it@granadainsurance.com,vkrysanov@sgsdt.com'
    to = 'vkrysanov@sgsdt.com'
    submissionNo = ""

    if s == "No premium transactions for the given period"
      t = "- no records"
    elsif s.start_with?( "Method call successful" )
      t = "successful"
      submissionNo = " ##{s[-6..-1]}"
    else
      t = "failure"
    end

    subject = "FSLSO Automation #{t} (#{( start + 1.minute ).strftime("%m/%d/%Y")} - #{ ( Time.now.midnight - 1.minute ).strftime("%m/%d/%Y")})#{submissionNo}"

    Processalert.sendalertsimple( to, subject, s )
  end
  rescue Exception => e
    s = "Caught #{e} exception:
        Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
    to = 'vkrysanov@sgsdt.com'
    subject = "FSLSO Automation submission exception caught"
    Processalert.sendalertsimple to, subject, s
  end
end
