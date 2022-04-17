class GicwebpolicyserviceController < ApplicationController
  def getactivepolicies
    if params[:key]  == "U8twG334wrwb4234fgs"
      @producingagency = Producingagency.where(agency_code: params[:agency_code]).where( status: :Active ).order("id DESC").first

      render :template => 'gicwebpolicyservice/activepolicies.xml.builder', :layout => false

    else
      redirect_to "/"
      logger.warn "UNAUTHORIZED CONNECTION ATTEMPT INVOICES"
    end
  end


  def getactivepoliciessinglequery
    if params[:key] != "U8twG334wrwb4234fgs"
      redirect_to "/"
      logger.warn "UNAUTHORIZED CONNECTION ATTEMPT INVOICES"
    else

      sql = "
		UPDATE documents SET hashvalidtill = current_timestamp + interval '1 minute' WHERE id IN (
			SELECT d.id
			FROM producingagencies pa
				JOIN policies p ON p.producingagency_id = pa.id
				JOIN documents d ON d.policy_id = p.id AND d.created_at > '2018-04-16' AND
						( name LIKE 'Cancellation%'
						OR name LIKE 'Final Audit%'
						OR name LIKE 'New Business%'
						OR name LIKE 'Reinstatement%'
						OR name LIKE 'Renewal Offer%'
						OR name LIKE 'Non-Renewal%'
						OR name LIKE 'Endorsement –%' )
			WHERE pa.status = 'Active' AND pa.agency_code = '#{params[:agency_code].gsub( "'", "''" )}'
		)"
      policies = ActiveRecord::Base.connection.execute sql

      sql = "
		SELECT p.id p_id, p.policy_number
			, to_char( p.effective_date, 'MM-DD-YYYY' ) p_effective_date
			, to_char( p.expiration_date, 'MM-DD-YYYY' ) p_expiration_date
			, n.named_insured
			, ppt.premium
			, c.carrier_name
			, l.line_name
			, p.is_nonrenew
			, p.is_pendingcancellation
			, d.id d_id
			, d.name d_name
			, to_char( d.created_at, 'MM-DD-YYYY' ) d_created_at
			, d.image_file_size
		FROM producingagencies pa
			JOIN policies p ON p.producingagency_id = pa.id
			LEFT JOIN namedinsureds n ON n.id = p.namedinsured_id
			LEFT JOIN carriers c ON c.id = p.carrier_id
			LEFT JOIN lineofbusinesses l ON l.id = CAST( p.lineofbusiness_id AS int )
			LEFT JOIN documents d ON d.policy_id = p.id AND d.created_at > '2018-04-16' AND
					( name LIKE 'Cancellation%'
					OR name LIKE 'Final Audit%'
					OR name LIKE 'New Business%'
					OR name LIKE 'Reinstatement%'
					OR name LIKE 'Renewal Offer%'
					OR name LIKE 'Non-Renewal%'
					OR name LIKE 'Endorsement –%' )
			LEFT JOIN (
					SELECT SUM( base_premium ) premium, policy_id
					FROM policypremiumtransactions
					WHERE transaction_type IN ( 'New', 'Renew', 'Endorse', 'Adjust', 'Return Premium' )
					GROUP BY policy_id
				) ppt ON ppt.policy_id = p.id
		WHERE pa.status = 'Active' AND pa.agency_code = '#{params[:agency_code].gsub( "'", "''" )}'
		ORDER BY pa.id DESC, p.effective_date DESC, d.created_at DESC"
      policies = ActiveRecord::Base.connection.exec_query sql

      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<activepolicies>"
      firsttime = true
      prev = ""

      policies.each do |p|
        p_id = p['p_id']
        if prev != p_id
          prev = p_id
          if firsttime
            firsttime = false
          else
            xml = xml + "
		</documents>
	</policy>"
          end
          xml = xml + "
	<policy>
		<policy_number>#{p['policy_number'].gsub("&","&amp;")}</policy_number>
		<effective_date>#{p['p_effective_date']}</effective_date>
		<expiration_date>#{p['p_expiration_date']}</expiration_date>
		<named_insured>#{p['named_insured'].gsub("&","&amp;")}</named_insured>
		<premium>#{p['premium']}</premium>
		<carrier>#{p['carrier_name'].gsub("&","&amp;")}</carrier>
		<lineofbusiness>#{p['line_name'].gsub("&","&amp;")}</lineofbusiness>
		<is_nonrenew>#{ p['is_nonrenew'] == 't' ? 'true' : 'false' }</is_nonrenew>
		<is_cancellationpending>#{ p['is_pendingcancellation'] == 't' ? 'true' : 'false' }</is_cancellationpending>
		<documents>"
        end
        d_id = p['d_id']
        unless d_id.blank?
          xml = xml + "
			<documentid>#{d_id}</documentid>
			<documentname>#{p['d_name'].gsub("&","&amp;")}</documentname>
			<documenturl>#{request.protocol}#{request.host}#{ ( [80,443].include? request.port ) ? "" : ":" + request.port.to_s }/gicwebdocservice/#{ Digest::MD5.hexdigest d_id + p['image_file_size'] }/#{d_id}</documenturl>
			<createddate>#{p['d_created_at']}</createddate>"
        end
      end

      xml = xml + "
		</documents>
	</policy>
</activepolicies>"

      render xml: xml#, content_type: 'text/html'
    end
  end


  def getdocument
    d = Document.where( "id = ?", params[:id]).first
    if d.nil? || params[:key] != Digest::MD5.hexdigest( "#{d.id}#{d.image_file_size}" ) || d.hashvalidtill < Time.now
      not_found
    end
    redirect_to d.authenticated_url
  end
end
