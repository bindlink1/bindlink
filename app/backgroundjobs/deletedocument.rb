class Deletedocument  < Struct.new(:document_id)

  def perform

    Document.find(document_id).destroy

  end


  def success(job)

  end





end