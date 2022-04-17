task :destroy_policy, [:pw, :pol_id] =>:environment do |t, args|
  if args[:pw] == 'chubbyrabbit'
    pol = Policy.find(args[:pol_id])
    pol.destroy
    puts "Policy Destroyed"
  end
end

task :generatesinglepptacct, [:pw, :ppt_id] =>:environment do |t, args|
  if args[:pw] == 'chubbyrabbit'
    ppt = Policypremiumtransaction.find(args[:ppt_id])
    ppt.createbookmonthyear
    ppt.accountingprocessexinv
    ppt.addtowarehouse
    if ppt.transaction_type == 'Cancel'
      if ppt.policy.arbalance != 0
        ppt.policy.cancellationtoinvoice(ppt.total_premium, ppt.base_premium, ppt.complexfees, ppt.id)

      else
        ## calculate commission to subtract from return
        producercommamt = 0
        if ppt.policy.isga =="GA"

          @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", ppt.policy.carrier_id,ppt.policy.lineofbusiness_id )
          @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, ppt.policy.state )

          producercommamt = (ppt.base_premium *  @commission[0].producer_rate)

        end


        @accountingevent = Accountingevent.new

        @accountingevent.transaction_type = 'Cancel Applied to Invoice Overage'
        @accountingevent.policy_id =  ppt.policy.id
        @accountingevent.total_premium = ppt.total_premium
        @accountingevent.base_premium = ppt.base_premium - producercommamt  + ppt.complexfees
        @accountingevent.carrier_id = ppt.policy.carrier.id
        @accountingevent.state = ppt.policy.state
        @accountingevent.line_id = ppt.policy.lineofbusiness_id

        @accountingevent.policypremiumtransaction_id = ppt.id
        @accountingevent.recordaccountingevent
      end
    end
  end
end



task :destroy_ppt_children, [:pw, :ppt_id] =>:environment do |t, args|
  if args[:pw] == 'chubbyrabbit'
    ppt = Policypremiumtransaction.find(args[:ppt_id])

    ppt.accountingtransactions.each do |at|
      at.destroy
    end

    ppt.feetransactions.each do |ft|
      ft.destroy
    end
  end

end


task :generatepolpptacct, [:pw, :pol_id] =>:environment do |t, args|

  pol = Policy.find(args[:pol_id])
  pol.policypremiumtransactions.each do |ppt|
    puts ppt.id
    Rake::Task[:generatesinglepptacct].invoke('chubbyrabbit', ppt.id)
    Rake::Task[:complexfeesacc].invoke(pol.id, ppt.id)
  end

end

task :bookpayments, [:pol_id] =>:environment do  |t, args|

end


task :complexfeesacc, [:pol_id, :ppt_id] =>:environment do |t, args|
  pol = Policy.find(args[:pol_id])


  lobfee = Lobfee.find_all_by_lineofbusiness_id(pol.lineofbusiness_id)


  ppt = Policypremiumtransaction.find(args[:ppt_id])

  basep = ppt.base_premium

  #add revenue fees to base premium
  lobfee.each do |lobf|
    if ppt.transaction_type == 'New' or ppt.transaction_type == 'Renew'
      if lobf.fee.fee_remit_type  == "Revenue"
        basep = basep + lobf.fee.fee_value
      end
    end

  end

  #calculate and save each fee
  lobfee.each do |lobf|
    if lobf.fee.fee_remit_type == "Revenue"
      if ppt.transaction_type == 'New' or ppt.transaction_type == 'Renew'
        ft = Feetransaction.new
        if lobf.fee.fee_type  == "Flat"
          ft.fee_amount = lobf.fee.fee_value
        else
          ft.fee_amount =  (basep * lobf.fee.fee_value).round(2)
        end
        ft.fee_id = lobf.fee.id
        ft.lobfee_id = lobf.id
        ft.policy_id = pol.id
        ft.policypremiumtransaction_id = ppt.id
        ft.save
      end

    else

      if lobf.fee.attach_type == 'Always'
        ft = Feetransaction.new
        if lobf.fee.fee_type  == "Flat"
          ft.fee_amount = lobf.fee.fee_value
        else
          ft.fee_amount =  (basep * lobf.fee.fee_value).round(2)
        end
        ft.fee_id = lobf.fee.id
        ft.lobfee_id = lobf.id
        ft.policy_id = pol.id
        ft.policypremiumtransaction_id = ppt.id
        ft.save
      else
        if ppt.transaction_type == 'New'  or ppt.transaction_type == 'Renew'
          ft = Feetransaction.new
          if lobf.fee.fee_type  == "Flat"
            ft.fee_amount = lobf.fee.fee_value
          else
            ft.fee_amount =  (basep * lobf.fee.fee_value).round(2)
          end
          ft.fee_id = lobf.fee.id
          ft.lobfee_id = lobf.id
          ft.policy_id = pol.id
          ft.policypremiumtransaction_id = ppt.id
          ft.save
        end

      end
    end




  end



end