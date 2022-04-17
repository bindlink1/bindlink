class Createdocument  < Struct.new(:td)



  def perform
    s3 = AWS::S3.new(
      :access_key_id => 'AKIAIRJG3ROQFYOLQZXQ',
      :secret_access_key => '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')
  bucket = s3.buckets['bindlink']

    begin
      obj = bucket.objects[td.s3_path.to_s]

      newdoc = Document.new
      # working code
      open("#{Rails.root}/tmp/#{td.file_name.to_s}", 'wb') do |file|
        file << obj.read
        newdoc.image = file

      end
      newdoc.created_at = td.created_date
      newdoc.generalagency_id = 1

      if !td.policy_id.nil?
        newdoc.policy_id = td.policy_id
        newdoc.name = td.file_desc.gsub(/[^0-9A-Za-z]/, '').to_s
        if newdoc.save
          td.upload_status = "Done"
          td.save
        end

      elsif !td.quote_id.nil?
        newdoc.quote_id = td.quote_id
        newdoc.name = td.file_desc.gsub(/[^0-9A-Za-z]/, '').to_s
        if newdoc.save
          td.upload_status = "Done"
          td.save
        end
      end

    rescue => error
      td.upload_error = error
      td.save

    end

  end


  def success(job)

  end





end