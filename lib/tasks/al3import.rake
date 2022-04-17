task :al3import => :environment do

  s3config = YAML.load_file("#{::Rails.root}/config/amazon_s3.yml")

  AWS.config(:access_key_id => s3config[::Rails.env]["access_key_id"], :secret_access_key => s3config[::Rails.env]["secret_access_key"])
  s3 = AWS::S3.new

  albucket = s3.buckets['IvansDownloads']


  @alfiles = Al3file.where("processed = false").all

  @alfiles.each do |alf|

    file = albucket.objects["#{alf.file_name}"]
    begin
      File.open("tmp.al3", "w") do |f|
        f.write(file.read)
      end
      tmp = File.read("tmp.al3")
    rescue
      file = albucket.objects["#{alf.file_name}"]

      tmpfile = file.read

      tmpfile.encode!(Encoding::UTF_8,  :undef => :replace, :replace => '^')
      puts "before"
      puts tmpfile

      File.open("tmp.al3", "w") do |f|

        f.write(tmpfile)

      end
      preconvert = File.read("tmp.al3")

      #puts preconvert
      convert = Al3hexconverter.new
      convert.convertal3file(preconvert)
      tmp = File.read("tmp.al3")

      puts "after"
      puts tmp
    end


    pointerlag = 0


    while pointerlag < tmp.size
      # puts pointerlag
      pointer = pointerlag + 3
      header = tmp[pointerlag..pointer]




      glen = tmp[(pointer+1)..(pointer +3)]

      al3reader = Al3reader.new
      al3reader.agency_id = alf.agency_id
      al3reader.header = header
      # puts header
      al3reader.alline = tmp[pointerlag..(pointerlag + glen.to_f)]

      if header == "2TRG"
        lagid = nil
        trgid = nil
        bpiid = nil
        vehid = nil
        trgid = al3reader.processgroup



      elsif header == "5BPI"

        al3reader.trgid = trgid
        bpiid = al3reader.processgroup

      elsif header == "5LAG"
        al3reader.bpiid = bpiid
        lagid = al3reader.processgroup

      elsif header == "5VEH"
        al3reader.lagid = lagid
        vehid = al3reader.processgroup


      else

        al3reader.trgid = trgid
        al3reader.vehid = vehid
        al3reader.lagid = lagid
        al3reader.trgid = trgid
        al3reader.bpiid = bpiid
        al3reader.processgroup
      end

      pointerlag = pointerlag + glen.to_f
    end


    alf.processed = true
    alf.save
    File.delete("tmp.al3")
  end


end

