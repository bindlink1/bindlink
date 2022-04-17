task :policyrenewalemail => :environment do
  if (1..5).include? Date.today.wday
    data = []
    report = []
    error = ""

    begin
      data.push [ Policy.policyrenewalbyperiod( 16, "Agency" ), 26 ]
      data.push [ Policy.policyrenewalbyperiod(  6, "Agency" ), 16 ]
      data.push [ Policy.policyrenewalbyperiod(  0, "Agency" ), 6 ]

      data.each do | d |
        report += PoliciesController.processrenewalsportion d[0], d[1]
      end
    rescue StandardError => ex
      error = ex.message
    end

    subject = "Renewal job finished. "
    body = ""
    if error != ""
      subject += "Error occured"
      body = error
    elsif report.size == 0
      subject += "No emails to send out"
    else
      days = 0
      error_count = 0
      body = "<table border=\"0\" cellpadding=\"5\" cellspacing=\"5\">
			<tr>
				<td style=\"background-color:#d6d6d6; font-weight:bold\">Exp. Date</td>
				<td style=\"background-color:#d6d6d6; font-weight:bold\">Policy</td>
				<td style=\"background-color:#d6d6d6; font-weight:bold\">Named Insured</td>
				<td style=\"background-color:#d6d6d6; font-weight:bold\">Email Recepient(s)</td>
			</tr>"
      i = 0
      report.each do | r |
        error_count += 1 unless r[5].empty?
        if r[6] != days
          i = 0
          days = r[6]
          body += "
			<tr>
				<td style=\"background-color:#e7e7e7; font-weight:bold\" colspan=\"4\">#{days} days</td>
			</tr>"
        end
        body += "
			<tr>
				<td#{ i % 2 == 1 ? " style=\"background-color:#f5f5f5;\"" : "" }>#{r[0].strftime("%m/%d/%Y")}</td>
				<td#{ i % 2 == 1 ? " style=\"background-color:#f5f5f5;\"" : "" }><a href=\"https://www.bindlink.com/policies/#{r[1]}\">#{r[2]}</a></td>
				<td#{ i % 2 == 1 ? " style=\"background-color:#f5f5f5;\"" : "" }>#{r[3]}</td>
				<td#{ i % 2 == 1 ? " style=\"background-color:#f5f5f5;\"" : "" }>#{r[4]}#{ r[5].empty? ? "" : "<br><span style=\"color:red\">#{r[5]}</span>" }</td>
			</tr>"
        i += 1
      end
      body += "</table>"

      if error_count == 0
        subject += "#{report.size} email#{ report.size == 1 ? " was" : "s were" } sent out"
      else
        subject += "#{error_count} error#{ error_count == 1 ? " was" : "s were" } found!"
        if report.size - error_count > 0
          subject += " #{report.size - error_count} email#{ report.size - error_count == 1 ? " was" : "s were" } sent out"
        end
      end
    end

    Processalert.sendrenewalreport( subject, body )
  end
end


