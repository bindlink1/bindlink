class Generatereturnlist  < Struct.new(:returnpremiumbatch_id, :generalagency_id)

  def perform
     returnpremiums = Cashtransaction.new.policieswithreturn(generalagency_id)

     Returnpremiumbatchpreitem.new.generatebatch(returnpremiums,returnpremiumbatch_id)

  end

  def success(job)
    rpb = ReturnPremiumBatch.find(returnpremiumbatch_id)
    rpb.changestatus('Ready')
  end



end