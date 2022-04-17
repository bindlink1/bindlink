
class Createdocumentpages  < Struct.new(:document_id)

  def perform
    document = Document.find(document_id)
    qfr = "#{Rails.root}/tmp/#{SecureRandom.hex(8)}.pdf"

    # working code
    open(qfr.to_s, 'wb') do |file|

      obj = document.image.s3_object(:original)
      file << obj.read



    end

    Paperclip.run('convert', "-limit memory 512MiB -quality #{Documentpage::QUALITY} -density #{Documentpage::DENSITY} #{qfr} #{qfr}%d.png")


    images = Dir.glob("#{qfr}*.png").sort_by do |line|


      line2 = line[(line.rindex('.png')-7)..line.rindex('.png')-1]

      ind = line2[line2.rindex('pdf')+3..9]

      Delayed::Job.enqueue Createdocumentpagesindv.new(line, ind, document_id)

    end




  end

  def success(job)


  end



end
