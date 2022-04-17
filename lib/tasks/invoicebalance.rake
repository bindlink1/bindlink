task :invoicebalance => :environment do


  allinvoices = Invoice.find_by_sql("select * from invoices INNER JOIN policypremiumtransactions ON policypremiumtransactions.id = invoices.policypremiumtransaction_id INNER JOIN policies ON policies.id = policypremiumtransactions.policy_id WHERE policies.generalagency_id = 1")

  allinvoices.each do |i|

    begin
    i.current_balance = i.outstandingbalance
    i.save
    rescue

    end

  end

  Processalert.sendalert("mdesiato@bindlink.com","mdesiato@bindlink.com","Invoicebalance Done","allset").deliver



end

