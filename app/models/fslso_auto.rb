class FslsoAuto < ActiveRecord::Base
  self.set_table_name "fslsoauto"
  self.inheritance_column = :_type_disabled

  def addlog( startdate, enddate, success, manual, s, submissionNo )
  	@f = FslsoAuto.new
  	@f.created_at = Time.now
  	@f.period_start = startdate
  	@f.period_end = enddate
  	@f.success = success
  	@f.type = manual ? 'manual' : 'auto'
  	@f.message = s
    @f.status = ( [ '', '-1' ].include? submissionNo ) ? 'failed' : 'received'
    @f.submissionno = submissionNo
    @f.save
  end


  def checkSubmissionResponse
    requestXml = '<GetSubmissionResponse xmlns="http://fslso.com/BatchFiling">
      <SubmissionNumber>' + self.submissionno + '</SubmissionNumber>
    </GetSubmissionResponse>'

    s = FslsoAuto.callFslsoService requestXml
#puts s
    doc = Nokogiri::XML s
    doc.remove_namespaces!
    statusMessage = doc.at_css 'StatusMessage'
    unless statusMessage.nil?
      s2 = statusMessage.content
      #puts s
      if s2 == 'Method call successful.'
        s = doc.at_css( 'Response' ).content
        unless s.blank?
          s = Base64.decode64 s
          s2 = ''
          i = 0
          while i < s.length
            s2 = s2 + s[i] #change encoding manually - every even char is 0x0 thus terminating the string after the 1st char
            i = i + 2
          end
          #puts s2
          s = s2
          doc = Nokogiri::XML s
          doc.remove_namespaces!
          r = doc.at_css 'RejectionHeader'
          unless r.nil?
            s = r.content + " (##{self.submissionno})"
            doc.xpath('//RejectionReason/Text').each do |t|
              s = s + "\n" + t.text
            end

            self.status = 'rejected'
            self.success = false
          else
            r = doc.at_css 'AcceptedHeader'
            unless r.nil?
              s = "This submission ##{self.submissionno} was accepted."
              r = doc.at_css 'AcceptedTransactions'
              s = s + ( r.nil? ? '' : "\nAccepted transactions: " + r.content )
              r = doc.at_css 'AcceptedPremium'
              s = s + ( r.nil? ? '' : "\nAccepted premium: " + r.content )
              r = doc.at_css 'AcceptedFees'
              s = s + ( r.nil? ? '' : "\nAccepted fees: " + r.content )

              self.status = 'accepted'
              self.success = true
            end
          end
        end
      end
    end
    #puts s
    self.message = s
    self.save
  end


  def self.callFslsoService requestXml
    requestXml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <AuthenticationHeader xmlns="http://fslso.com/BatchFiling">
      <UserName>l060903</UserName>
      <APIKey>gic4690</APIKey>
    </AuthenticationHeader>
  </soap:Header>
  <soap:Body>
    ' + requestXml + '
  </soap:Body>
</soap:Envelope>'

    #puts Rails.configuration.fslsourl
    uri = URI.parse Rails.configuration.fslsourl
    #uri = URI.parse('http://sliptest.fslso.com/webservice/fslsobatchfiling.asmx')
    #uri = URI.parse 'http://slip.fslso.com/webservice/fslsobatchfiling.asmx'
    http = Net::HTTP.new uri.host, uri.port

    request = Net::HTTP::Post.new uri.request_uri

    request.body = requestXml

    request["Content-Type"] = "text/xml; charset=utf-8"

    #puts '-------------'
    #puts request.body
    #puts '-------------'

    response = http.request request

    #puts '-------------------------------------------------------'
    #puts subm.submissionno
    #puts response.code
    #puts response.body
    #puts '-------------------------------------------------------'

    s = response.body
  end
end