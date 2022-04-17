xml.instruct!
xml.invoices do
  @policy.invoices.each do |invoice|
    xml.invoice do
      xml.id invoice.id
      xml.due_on invoice.due_on
      xml.total_billed invoice.total_billed
      xml.status invoice.isoverdue
      if invoice.outstandingbalance == 0 
      	xml.balance invoice.outstandingbalance
      else
      	xml.balance invoice.outstandingbalance - invoice.policypremiumtransaction.pptcommissionproducer
      end
    end
  end

end
