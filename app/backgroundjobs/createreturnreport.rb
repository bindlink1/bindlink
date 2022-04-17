class Createreturnreport  < Struct.new( :emailtosendto, :startdate, :enddate )

  def perform
    agencyid = 1
    atype =  "GA"

    returnpremiums = Cashtransaction.new.policieswithreturn( agencyid, startdate, enddate )

    pdf = ReturnpremiumreportPdf.new(returnpremiums)

    Outboundemail.sendsimple('mdesiato@gicunderwriters.com',emailtosendto,'Return Premium Report','See attached',pdf).deliver!


  end

  def success(job)

  end



end