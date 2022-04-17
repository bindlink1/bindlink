
class Createdocumentpagesindv  < Struct.new(:line, :ind, :document_id)

  def perform
      line.match(/(\d+)\.png$/)[1].to_i

      dp = Documentpage.new
      dp.document_id = document_id
      dp.image = File.open(line)
      dp.page_number = ind
      dp.save
      FileUtils.rm line

  end

  def success(job)

  end



end
