class Createagingreport  < Struct.new(:emailtosendto)
  def perform
    agencyid = 1
    atype    =  "GA"

    @invoices30 = Report.new.agingreport(agencyid, 0,  30, atype)
    @invoices60 = Report.new.agingreport(agencyid, 31, 60, atype)
    @invoices90 = Report.new.agingreport(agencyid, 61, 90, atype)

    @invoicesover = Report.new.agingreport(agencyid, 91, 5000, atype)

    pdf = AgingreportPdf.new(@invoices30, @invoices60, @invoices90, @invoicesover)

    Outboundemail.sendsimple('mdesiato@gicunderwriters.com', emailtosendto, 'Aging Invoice Report', 'Report', pdf).deliver!
  end

  def success(job)
  end
end