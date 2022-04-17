task :convertdocuments => :environment do

=begin
  s3 = AWS::S3.new(
      :access_key_id => 'AKIAIXNK6DTRRJN22G6Q',
      :secret_access_key => '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')
  bucket = s3.buckets['bindlink']

=end

  begin

    tempdocs = Tempdocs.all
    tempdocs.each do |td|
        Delayed::Job.enqueue Createdocument.new(td)

    end




  rescue => error
    puts " THIS IS AN ERROR"
    puts error

  end

  #end

end