class Generatecompaylist  < Struct.new(:compaybatch_id, :generalagency_id)

  def perform
     compays = Cashtransaction.new.policieswithcompay(generalagency_id)

     Compaybatchpreitem.new.generatebatch(compays,compaybatch_id)

  end


  def success(job)
    cpb = CompayBatch.find(compaybatch_id)
    cpb.changestatus('Ready')
  end





end