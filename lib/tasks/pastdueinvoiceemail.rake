task :pastdueinvoiceemail => :environment do
  #puts Time.now.in_time_zone("America/New_York").strftime("%b %d, %Y %l:%M %p (%Z)").gsub( "  ", " " )
  if (1..5).include? Date.today.wday
    data = []
    report = []
    error = ""

    begin
      inv = Invoice.pastdueinvoice( 15, 19 ).
        joins( "
          LEFT JOIN emails e ON e.subject LIKE CONCAT( p2.policy_number, ': past due invoice%' ) AND e.created_at > current_date - 10" ).
        where( "
          e.id IS NULL " )
      data.push [ inv, 15 ]
      inv = Invoice.pastdueinvoice( 20, 26 )
      data.push [ inv, 20 ]

      data.each do | d |
        report += PoliciesController.processpastdueportion d[0], d[1]
      end
    rescue StandardError => ex
      error = ex.message
    end

    subject = "Past Due Invoice job finished. "
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
				<td style=\"background-color:#d6d6d6; font-weight:bold\">Due Date</td>
        <td style=\"background-color:#d6d6d6; font-weight:bold\">Amount</td>
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
          if days == 15
            dd = "15-19"
          else
            dd = "20-26"
          end
          body += "
			<tr>
				<td style=\"background-color:#e7e7e7; font-weight:bold\" colspan=\"5\">#{dd} days</td>
			</tr>"
        end
        body += "
			<tr>
				<td#{ i % 2 == 1 ? " style=\"background-color:#f5f5f5;\"" : "" }>#{r[0].strftime("%m/%d/%Y")}</td>
        <td style=\"text-align:right;#{ i % 2 == 1 ? " background-color:#f5f5f5;" : "" }\">#{r[7]}</td>
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


