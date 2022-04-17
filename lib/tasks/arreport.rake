task :arreport => :environment do


  agencyid = 1
  atype =  "GA"


  @invoices30 = Report.new.agingreport(agencyid,0,30, atype)


  @invoices60 = Report.new.agingreport(agencyid,31,60, atype)


  @invoices90 = Report.new.agingreport(agencyid,61,90, atype)


  @invoicesover = Report.new.agingreport(agencyid,91,5000,atype)





  pdf = AgingreportPdf.new(@invoices30, @invoices60, @invoices90, @invoicesover)


  puts "complete1"

  Outboundemail.sendsimple('mdesiato@gicunderwriters.com','cdp@granadainsurance.com','Positive','test',pdf).deliver

  returnpremiums = Cashtransaction.new.policieswithreturn(agencyid)

  pdf2 = ReturnpremiumreportPdf.new(returnpremiums)



  Outboundemail.sendsimple('mdesiato@gicunderwriters.com','cdp@granadainsurance.com','Negative','test',pdf2).deliver



end

