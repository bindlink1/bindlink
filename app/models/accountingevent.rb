class Accountingevent
  attr_accessor :transaction_type, :total_premium,:total_billed, :policy_id, :invoice_id, :created_date, :carrier_id, :cash_received, :policypremiumtransaction_id, :line_id, :state, :fees, :base_premium, :complexfees, :cashtransactions_id


  def initialize()
    @transaction_type = transaction_type
    @total_premium = total_premium
    @total_billed = total_billed
    @policy_id= policy_id
    @created_date = created_date
    # @agency_id = agency_id
    @carrier_id = carrier_id
    @line_id = line_id
    @state = state
    @invoice_id = invoice_id
    @cashreceived = cash_received
    @fees = fees
    @complexfees = complexfees
    @base_premium = base_premium
    @policypremiumtransaction_id = policypremiumtransaction_id
    @cashtransactions_id = cashtransactions_id

  end

  def recordaccountingevent
    @policy = Policy.find(policy_id)

    if !@policypremiumtransaction_id.nil?
      ppt = Policypremiumtransaction.find(@policypremiumtransaction_id)
    end

    if @complexfees.nil?
      @complexfees = 0
    end


    if @policy.isga == "GA"
      @gastatus = true

    end

     @producercommamt = 0



    if @transaction_type != 'Reinstate'
      if @transaction_type != 'Cancel Pending Statement'
        if @transaction_type != 'Cash'
          if @transaction_type != 'Carrier Payment'
            if @transaction_type != 'Return'
              if @transaction_type !=  'Commission Payable'
                if @transaction_type !=  'Commission Receivable'
                # get commission % for LOB and carrier being cancelled
                @carrier = Carrier.find(carrier_id)
                @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", carrier_id,line_id )

                @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, state )
                ############################################################################################################
                #  to do: need to make a distinction if policy was new or a renewal and pull commission corresponding      #
                #         to the transaction type                                                                          #
                #                                                                                                          #
                ############################################################################################################


                # store producer commission if a producer rate exists
                begin

                  if !@commission[0].producer_rate.nil?




                    #check to see if policy has a conditional commission override from default
                    if !@policy.cond_comm_producer.nil?
                      @producercommrate =  @policy.cond_comm_producer

                    else
                      @producercommrate =  @commission[0].producer_rate
                    end

                    #calculate producer commission
                    @producercommamt = (base_premium *  @producercommrate).round(2)
                    @producercomm = Producercommission.new
                    @producercomm.commission_value =  @producercommamt
                    @producercomm.transaction_type = @transaction_type

                    @producercomm.generalagency_id =  @policy.generalagency_id
                    @producercomm.producer_id =  @policy.producingagency_id
                    @producercomm.policy_id = @policy.id
                    @producercomm.policypremiumtransaction_id = @policypremiumtransaction_id

                    @producercomm.save
                  end


                rescue
                end

                # calculate commission for transaction, if the policy has an override, apply it


                if !@policy.agency_comm_override.nil?
                  @commissionamount = (base_premium * @policy.agency_comm_override).round(2)
                else
                  @commissionamount = (base_premium * @policy.commissionrate).round(2)
                end




                @duetocarrier = total_premium  - @commissionamount  - @complexfees
              end
              end
            end
          end
        end
      end
    end

    # NEW BUSINESS transactions ################################################
    ############################################################################

    # Agency Bill - FULL NET
    if @transaction_type == 1

##
## Premium Receivable Section
# handling adjustments which may reduce new transaction
      if  (@total_premium - @producercommamt)  < 0
        # turn positive
        amount = (@total_premium - @producercommamt) * -1

        #apply amount to receivable first

        if @policy.accountbalance(10006, 'Asset') > 0
          # reduce receivable
          if  @policy.accountbalance(10006, 'Asset')  > amount
            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.account_id = 10006  #premium receivable from producing agency
            @accountingtransactions.amount =  amount
            @accountingtransactions.trans_type = 'Credit'
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save
          else
            #reduce recievable
            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.account_id = 10006  #premium receivable from producing agency
            @accountingtransactions.amount =   @policy.accountbalance(10006, 'Asset')
            @accountingtransactions.trans_type = 'Credit'
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save
                                                        # remainder to payable
            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.account_id = 20006  #premium payable to producing agency
            @accountingtransactions.amount =   amount - @policy.accountbalance(10006, 'Asset')
            @accountingtransactions.trans_type = 'Credit'
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save

          end
        else #credit payable
          @accountingtransactions = Accountingtransaction.new
          @accountingtransactions.policy_id = @policy_id
          @accountingtransactions.account_id = 20006  #premium payable to producing agency
          @accountingtransactions.amount =   amount
          @accountingtransactions.trans_type = 'Credit'
          @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
          @accountingtransactions.save
        end

      else #create premium receivable transation (from producer or policyholder) - Asset DEBIT


        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.policy_id = @policy_id

        if @gastatus
          @accountingtransactions.account_id = 10006  #premium receivable from producing agency
          @accountingtransactions.amount = @total_premium - @producercommamt

        else
          @accountingtransactions.account_id = 10002   #premium receivable from policyholder
          @accountingtransactions.amount = @total_premium
        end

        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
        @accountingtransactions.save
      end

      ## end premium receivable section


      ## Premium Payable Section
      #create premium payable - Liability - Credit

      #check if adjustment
      if  @duetocarrier < 0
        # turn positive
        amount = @duetocarrier * -1

        if @policy.accountbalance(20001, 'Liability') > 0
          #reduce payable to carrier

          if @policy.accountbalance(20001, 'Liability') > amount
            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.account_id = 20001  #premium payable to carrier
            @accountingtransactions.amount =  amount
            @accountingtransactions.trans_type = 'Debit'
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save
          else

            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.account_id = 20001  #premium payable to carrier
            @accountingtransactions.amount =   @policy.accountbalance(20001, 'Liability')
            @accountingtransactions.trans_type = 'Debit'
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save
                                                        # remainder to payable
            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.account_id = 10005  #premium receivable from carrier
            @accountingtransactions.amount =   amount - @policy.accountbalance(20001, 'Liability')
            @accountingtransactions.trans_type = 'Credit'
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save
          end
        else
          @accountingtransactions = Accountingtransaction.new
          @accountingtransactions.policy_id = @policy_id
          @accountingtransactions.account_id = 20001   # premium payable to carrier
          @accountingtransactions.amount =  @duetocarrier
          @accountingtransactions.trans_type = 'Debit'
          @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
          @accountingtransactions.save


        end

      else
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.policy_id = @policy_id
        @accountingtransactions.account_id = 20001   # premium payable to carrier
        @accountingtransactions.amount =  @duetocarrier
        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
        @accountingtransactions.save

      end

      ## end premium payable section

      #create commission income = Credit

      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 30001
      if @commissionamount < 0
        @accountingtransactions.amount = (@commissionamount * -1)
        @accountingtransactions.trans_type = 'Debit'
      else
        @accountingtransactions.amount = @commissionamount
        @accountingtransactions.trans_type = 'Credit'
      end
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

      if @gastatus
        #create commission expense = Debit
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.policy_id = @policy_id
        @accountingtransactions.account_id = 40001
        if @producercommamt < 0
          @accountingtransactions.amount = (@producercommamt * -1)
          @accountingtransactions.trans_type = 'Credit'
        else
          @accountingtransactions.amount = @producercommamt
          @accountingtransactions.trans_type = 'Debit'
        end
        @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
        @accountingtransactions.save
      end




    end

    #Agency Bill - FULL Gross
    if @transaction_type == 2
      @carrier = Carrier.find(carrier_id)



      #create premium receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10002
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

      #create premium payable - Liability - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20001
      @accountingtransactions.amount =  @total_premium - @complexfees
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save
    end

    #Agency Bill - Premium Finance - NET
    if @transaction_type == 3


      #create premium receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10002
      @accountingtransactions.amount = @total_billed #using the total billed from the invoice as the downpayment
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


      #create premium finance receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10004
      @accountingtransactions.amount = @total_premium - @total_billed
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

      #create premium payable - Liability  - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20001
      @accountingtransactions.amount =  @duetocarrier
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

      #create unearned commission = Liability  - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20002
      @accountingtransactions.amount = @commissionamount
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

    end

    #Agency Bill - Premium Finance - Gross
    if @transaction_type == 4




      #create premium receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10002
      @accountingtransactions.amount = @total_billed
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


      #create premium finance receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10004
      @accountingtransactions.amount = @total_premium - @total_billed
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

      #create premium payable - Liability  - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20001
      @accountingtransactions.amount =  @total_premium - @complexfees
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save



    end

    #Direct Bill <- 'traditional' direct bill. This does not generate an invoice
    if @transaction_type == 5

      #create commission receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10003
      @accountingtransactions.amount = @commissionamount
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


      #create unearned commission = Liability  - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20002
      @accountingtransactions.amount = @commissionamount
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

    end

    #Direct Bill - FULL Gross
    if @transaction_type == 6


      #create premium receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10002
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

      #create premium payable - Liability - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20001
      @accountingtransactions.amount =  @total_premium - @complexfees
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save
    end

    #Direct Bill - Installments - NET : Comission is earned as received from carrier
    if @transaction_type == 7

      #create premium receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10003
      @accountingtransactions.amount = @commissionamount
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


      #create unearned commission = Liability  - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20002
      @accountingtransactions.amount = @commissionamount
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

    end

    #Direct Bill - Installments - Gross
    if @transaction_type == 8




      #create premium receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10002
      @accountingtransactions.amount = @total_billed
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


      #create premium payable - Liability  - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20001
      @accountingtransactions.amount =  @total_billed
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save



    end

    #Direct Bill - Carrier
    if @transaction_type == 9




      #create premium receivable transation - Asset DEBIT
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10002
      @accountingtransactions.amount = @total_billed
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


      #create premium payable - Liability  - Credit
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20001
      @accountingtransactions.amount =  @total_billed
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save



    end

    ### END NEW BUSINESS TRANSACTIONS ############################################################
    ##############################################################################################

    if @transaction_type == 'Cancel'
      #since cancellations are negative we are reversing the sign passed
      if @gastatus
        @producercommamt = @producercommamt * -1
        @complexfees = @complexfees * -1
      end

      @commissionamount = @commissionamount * -1
      # to determine if this is direct bill, need to get the billing type using the lobcommission

      ######################################
      # DIRECT BILL Cancellation TRANSACTIONS
      if @commission[0].billing_type == 5





            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.account_id = 20002
            @accountingtransactions.amount = @commissionamount
            @accountingtransactions.trans_type = 'Debit'
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save



        #credit comm receviable 10003
        # evaluate if there should be a commission payable 20007
        # if commission amount > commission receivable then apply to comm rec until 0 then apply to payable

        if @commissionamount >  @policy.commissionreceivable
          commpayable = @commissionamount - @policy.commissionreceivable

          @accountingtransactions = Accountingtransaction.new
          @accountingtransactions.account_id = 20007
          @accountingtransactions.amount = commpayable
          @accountingtransactions.trans_type = 'Credit'
          @accountingtransactions.policy_id = @policy_id
          @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
          @accountingtransactions.save

          if @policy.commissionreceivable != 0
            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.account_id = 10003
            @accountingtransactions.amount = @policy.commissionreceivable
            @accountingtransactions.trans_type = 'Credit'
            @accountingtransactions.policy_id = @policy_id
            @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
            @accountingtransactions.save
          end

        else

          @accountingtransactions = Accountingtransaction.new
          @accountingtransactions.account_id = 10003
          @accountingtransactions.amount = @commissionamount
          @accountingtransactions.trans_type = 'Credit'
          @accountingtransactions.policy_id = @policy_id
          @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
          @accountingtransactions.save
        end
        # END DIRECT BILL TRANSACTIONS
        ########################################

      else   #agency bill net transactions

             ######################################
             # RETURN PREMIUM  from carrier
        @accountingtransactions = Accountingtransaction.new


        if self.cash_received == 'Yes'
          # CASH
          @accountingtransactions.account_id = 10001
          @accountingtransactions.amount = (@base_premium * (1- @policy.commissionrate) * -1).round(2)
          @accountingtransactions.trans_type = 'Debit'
          @accountingtransactions.policy_id = @policy_id
          @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
          @accountingtransactions.save
        else
          # Premium Receivable from Carrier
          # if there is a premium payable to carrier, offset it by the premium receivable


          self.acct_ind_trans(@policy_id,20001,'Debit',((@base_premium * (1- @policy.commissionrate) * -1).round(2)),policypremiumtransaction_id,'')

        end





        # END RETURN PREMIUM
        #######################################


        # if the policy is for a GA the producer will receive the return premium less their unearned commission
        # fees are returned, but commission is calculated off base premium

        #### PREMIUM SHOULD ONLY BE PAYABLE IF THEY HAVE A 0 BALANCE #######



        #@accountingtransactions = Accountingtransaction.new

        if @gastatus
          #Premium Payable to Producing Agency
          #@accountingtransactions.account_id = 20006
          #@accountingtransactions.amount = (@base_premium + @producercommamt+ @complexfees)  *-1
        else
          #Premium Payable to Policyhlder
          @accountingtransactions.account_id = 20004
          @accountingtransactions.amount = @total_premium  * -1
        end

        #@accountingtransactions.trans_type = 'Credit'
        #@accountingtransactions.policy_id = @policy_id
        #@accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
        #@accountingtransactions.save

        #######################################
        # REDUCE COMMISSION
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 30001
        @accountingtransactions.amount = @commissionamount
        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.policy_id = @policy_id
        @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
        @accountingtransactions.save
        # END REDUCE COMMISSION
        #######################################

        #######################################
        #if GA, REDUCE COMMISSION EXPENSE
        if @gastatus
          @accountingtransactions = Accountingtransaction.new
          @accountingtransactions.account_id = 40001
          @accountingtransactions.amount = @producercommamt
          @accountingtransactions.trans_type = 'Credit'
          @accountingtransactions.policy_id = @policy_id
          @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
          @accountingtransactions.save
        end
        # END REDUCE COMMISSION EXPENSE
        ######################################

      end
    end

    if @transaction_type == 'Cancel Applied to Invoice'
      ###!note: to use same method for all transactions, the variable @base_premium below is really the amount applied to the invoice
      @accountingtransactions = Accountingtransaction.new

      if @gastatus
        #reduce receivable from producer net commission

        #@accountingtransactions.account_id = 10006
        #@accountingtransactions.amount = (@base_premium  )

        self.acct_ind_trans(@policy_id,10006,'Credit',(@base_premium),policypremiumtransaction_id,'')

      else
        @accountingtransactions.account_id = 10002
        @accountingtransactions.amount = @total_premium

        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.policy_id = @policy_id
        @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
        @accountingtransactions.save
      end


    end

    if @transaction_type == 'Cancel Applied to Invoice Overage'
      ###!note: to use same method for all transactions, the variable @base_premium below is really what was left over after applying to invoices
      @accountingtransactions = Accountingtransaction.new

      if  @base_premium  < 0
        @base_premium = @base_premium * -1
      end
      if @gastatus


        self.acct_ind_trans(@policy_id,20006,'Credit',(@base_premium),policypremiumtransaction_id,'')
        #@accountingtransactions.account_id = 20006
        #changed to negative+ @complexfees - @producercommamt
        #@accountingtransactions.amount = (@base_premium *-1)
      else
        @accountingtransactions.account_id = 20004
        @accountingtransactions.amount = @base_premium

        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.policy_id = @policy_id
        @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
        @accountingtransactions.save
      end
    end

    if @transaction_type == 'Reinstate'



      #just reverse the transactions from the last cancel
      @canceltrans = Policypremiumtransaction.where("policy_id = ? AND (transaction_type = 'Cancel' OR transaction_type = 'Cancel Pending Statement')",policy_id).last

      @cancelacctingtrans = Accountingtransaction.find_all_by_policypremiumtransaction_id(@canceltrans.id)

      @cancelacctingtrans.each do |cat|

        if cat.reconcile_flag != 'Yes'



          #old
          #@accountingtransactions = Accountingtransaction.new
          #@accountingtransactions.policy_id = @policy_id
          #@accountingtransactions.account_id = cat.account_id
          #@accountingtransactions.amount =  cat.amount
          #old

          if cat.trans_type == 'Credit'


            if   cat.account_id == 40001   #handles return premium cash received from carrier, adds a payable instead of just reversing it
              @accountingtransactions = Accountingtransaction.new
              @accountingtransactions.policy_id = @policy_id
              @accountingtransactions.account_id = cat.account_id
              @accountingtransactions.amount =  cat.amount
              @accountingtransactions.account_id = 40001
              @accountingtransactions.trans_type = 'Debit'
              @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
              @accountingtransactions.save
            else


              self.acct_recordtransaction(@policy_id,cat.account_id,'Debit',cat.amount,policypremiumtransaction_id,'', 'Reinstate')
            end

            # old
            #@accountingtransactions.trans_type = 'Debit'
            #if cat.account_id == 20007   #handles return premium cash received from carrier, adds a payable instead of just reversing it
            #  @accountingtransactions.account_id = 10003
            #end

            #if cat.account_id == 10005
            #  @accountingtransactions.account_id = 20001
            #end
            # old

          else

            if cat.account_id == 10001   #handles return premium cash received from carrier, adds a payable instead of just reversing it
              @accountingtransactions = Accountingtransaction.new
              @accountingtransactions.policy_id = @policy_id
              @accountingtransactions.account_id = cat.account_id
              @accountingtransactions.amount =  cat.amount
              @accountingtransactions.account_id = 20001
              @accountingtransactions.trans_type = 'Credit'
              @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
              @accountingtransactions.save
            elsif cat.account_id == 40001   #handles return premium cash received from carrier, adds a payable instead of just reversing it
              @accountingtransactions = Accountingtransaction.new
              @accountingtransactions.policy_id = @policy_id
              @accountingtransactions.account_id = cat.account_id
              @accountingtransactions.amount =  cat.amount
              @accountingtransactions.account_id = 40001
              @accountingtransactions.trans_type = 'Debit'
              @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
              @accountingtransactions.save
            else


              self.acct_ind_trans(@policy_id,cat.account_id,'Credit',cat.amount,policypremiumtransaction_id,'')

            end

            # if cat.account_id == 10005
            # @accountingtransactions.account_id = 20001



          end

        end

      end







    end



    if @transaction_type == 'Return'
      # Credit Cash to return the premium
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.invoice_id = @invoice_id
      @accountingtransactions.account_id = 10001
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


      # Debit Premium Payable to Producer or Policyholder
      @accountingtransactions = Accountingtransaction.new

      if @gastatus
        @accountingtransactions.account_id = 20006
      else
        @accountingtransactions.account_id = 20004
      end

      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.invoice_id = @invoice_id
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save


    end

    if @transaction_type == 'Commission Payable'
      # Credit Cash for the commission payment
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10001
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.save

      # Debit Commission payable to producer
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 20005
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.save
    end

    if @transaction_type == 'Commission Receivable'
      # Debit Cash for the commission receibale
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10001
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.save

      # Debit Commission receivable from producer
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.account_id = 10004
      @accountingtransactions.trans_type = 'Credit'
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.save
    end

    if @transaction_type == 'Cash'

      #create premium receivable transation - Asset CREDIT
      @accountingtransactions = Accountingtransaction.new


      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.invoice_id = @invoice_id
      if @gastatus
        @accountingtransactions.account_id = 10006
      else
        @accountingtransactions.account_id = 10002
      end
      @accountingtransactions.trans_type = 'Credit'

      #make sure that you are returning money to policyholder if invoice is overpaid
      if @total_premium <=  @policy.arbalance then
        @accountingtransactions.amount = @total_premium
      else
        @accountingtransactions.amount = @policy.arbalance

        # to put the overpayment into premium payable to policyholder
        @accountingtransactionsovr = Accountingtransaction.new
        @accountingtransactionsovr.policy_id = @policy_id
        @accountingtransactionsovr.invoice_id = @invoice_id

        if @gastatus
          @accountingtransactionsovr.account_id = 20006
        else
          @accountingtransactionsovr.account_id = 20004
        end
        @accountingtransactionsovr.trans_type = 'Credit'
        @accountingtransactionsovr.amount = @total_premium - @policy.arbalance
        @accountingtransactionsovr.policypremiumtransaction_id = policypremiumtransaction_id
        @accountingtransactionsovr.cashtransaction_id = @cashtransactions_id
        @accountingtransactionsovr.save

      end

      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.save
      #todo change name of value to something more descriptive for cash received - total premium does not make sense
      #create cash transation - Asset DEBIT

      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.invoice_id = @invoice_id
      @accountingtransactions.account_id = 10001
      @accountingtransactions.trans_type = 'Debit'
      @accountingtransactions.amount = @total_premium
      @accountingtransactions.cashtransaction_id = @cashtransactions_id
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

    end

    if @transaction_type == 'Carrier Payment'

      #credit cash - Asset CREDIT
      @accountingtransactions = Accountingtransaction.new

      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.invoice_id = @invoice_id
      @accountingtransactions.account_id = 10001
      @accountingtransactions.trans_type = 'Credit'

      @accountingtransactions.amount = @total_premium
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save

      #debit AP to Carrier - Liability Debit
      @accountingtransactions = Accountingtransaction.new

      @accountingtransactions.policy_id = @policy_id
      @accountingtransactions.invoice_id = @invoice_id
      @accountingtransactions.account_id = 20001
      @accountingtransactions.trans_type = 'Debit'

      @accountingtransactions.amount = @total_premium
      @accountingtransactions.policypremiumtransaction_id = policypremiumtransaction_id
      @accountingtransactions.save




    end


  end


### This method will control all accountingtransaction entry
  def acct_recordtransaction(pol_id, account_id, trans_type, amount, ppt_id, reconcile_flag, reinstateflag)

    # overflow $$ go into contra asset account

    @policy = Policy.find(pol_id)

    accounting_account = Accountingaccount.where("account_id = ?", account_id).last()


    ca =  @policy.accountbalance(accounting_account.contra_account.account_id, accounting_account.contra_account.balance_sheet)
    a = amount

    tto = Proc.new {|tt, c, atype, catype|
      if c > 0

        if reinstateflag != 'Reinstate'

          if tt == 'Debit'
            'Credit'
          else
            'Debit'

          end
        else
          tt

        end

      end
    }

    if ca != 0



      if   a > ca
        accountingtransaction = Accountingtransaction.new
        accountingtransaction.account_id = accounting_account.contra_account_id
        accountingtransaction.amount = ca
        accountingtransaction.trans_type = tto.call(trans_type, ca, accounting_account.balance_sheet, accounting_account.contra_account.balance_sheet)
        accountingtransaction.policy_id = pol_id
        if ppt_id != 'none'
        accountingtransaction.policypremiumtransaction_id = ppt_id
        end
        accountingtransaction.reconcile_flag = reconcile_flag
        accountingtransaction.save

        accountingtransaction = Accountingtransaction.new
        accountingtransaction.account_id = account_id
        accountingtransaction.amount = (a - ca)
        accountingtransaction.trans_type = trans_type
        accountingtransaction.policy_id = pol_id
        if ppt_id != 'none'
          accountingtransaction.policypremiumtransaction_id = ppt_id
        end
        accountingtransaction.reconcile_flag = reconcile_flag
        accountingtransaction.save
      else
        accountingtransaction = Accountingtransaction.new
        accountingtransaction.account_id = accounting_account.contra_account_id
        accountingtransaction.amount = a
        accountingtransaction.trans_type = tto.call(trans_type, ca, accounting_account.balance_sheet, accounting_account.contra_account.balance_sheet)
        accountingtransaction.policy_id = pol_id
        if ppt_id != 'none'
          accountingtransaction.policypremiumtransaction_id = ppt_id
        end
        accountingtransaction.reconcile_flag = reconcile_flag
        accountingtransaction.save
      end
    else

      self.acct_ind_trans(pol_id, account_id, trans_type, a, ppt_id, reconcile_flag)

    end

  end

#ensures that there are no negative accounts
  def acct_ind_trans(pol_id, account_id, trans_type, amount, ppt_id, reconcile_flag)
    accounting_account = Accountingaccount.where("account_id = ?", account_id).last()
    policy = Policy.find(pol_id)

    acct_balance = policy.accountbalance(account_id, accounting_account.balance_sheet)


    if accounting_account.balance_sheet == 'Asset'
      if trans_type  == 'Credit'
        #ensure that we dont make this account negative
        if amount > acct_balance

          if acct_balance > 0
            accountingtransaction = Accountingtransaction.new
            accountingtransaction.account_id = account_id
            accountingtransaction.amount = acct_balance
            accountingtransaction.trans_type =  trans_type
            accountingtransaction.policy_id = pol_id
            if ppt_id != 'none'
              accountingtransaction.policypremiumtransaction_id = ppt_id
            end
            accountingtransaction.reconcile_flag = reconcile_flag
            accountingtransaction.save
          end

          #remainder in contra asset
          accountingtransaction = Accountingtransaction.new
          accountingtransaction.account_id = accounting_account.contra_account_id
          accountingtransaction.amount = amount - acct_balance
          accountingtransaction.trans_type =  trans_type
          accountingtransaction.policy_id = pol_id
          if ppt_id != 'none'
            accountingtransaction.policypremiumtransaction_id = ppt_id
          end
          accountingtransaction.reconcile_flag = reconcile_flag
          accountingtransaction.save

        else  # amount <= acct_balace - no danger of a negative account here
          accountingtransaction = Accountingtransaction.new
          accountingtransaction.account_id = account_id
          accountingtransaction.amount = amount
          accountingtransaction.trans_type =  trans_type
          accountingtransaction.policy_id = pol_id
          if ppt_id != 'none'
            accountingtransaction.policypremiumtransaction_id = ppt_id
          end
          accountingtransaction.reconcile_flag = reconcile_flag
          accountingtransaction.save
        end
      else # debit - no danger here
        accountingtransaction = Accountingtransaction.new
        accountingtransaction.account_id = account_id
        accountingtransaction.amount = amount
        accountingtransaction.trans_type =  trans_type
        accountingtransaction.policy_id = pol_id
        if ppt_id != 'none'
          accountingtransaction.policypremiumtransaction_id = ppt_id
        end
        accountingtransaction.reconcile_flag = reconcile_flag
        accountingtransaction.save
      end
    else #Liability
      if trans_type  == 'Debit'
        #ensure that we dont make this account negative
        if amount > acct_balance

          if acct_balance > 0
            accountingtransaction = Accountingtransaction.new
            accountingtransaction.account_id = account_id
            accountingtransaction.amount = acct_balance
            accountingtransaction.trans_type =  trans_type
            accountingtransaction.policy_id = pol_id
            if ppt_id != 'none'
              accountingtransaction.policypremiumtransaction_id = ppt_id
            end
            accountingtransaction.reconcile_flag = reconcile_flag
            accountingtransaction.save
          end

          #remainder in contra asset
          accountingtransaction = Accountingtransaction.new
          accountingtransaction.account_id = accounting_account.contra_account_id
          accountingtransaction.amount = amount - acct_balance
          accountingtransaction.trans_type =  trans_type
          accountingtransaction.policy_id = pol_id
          if ppt_id != 'none'
            accountingtransaction.policypremiumtransaction_id = ppt_id
          end
          accountingtransaction.reconcile_flag = reconcile_flag
          accountingtransaction.save

        else  # amount <= acct_balace - no danger of a negative account here
          accountingtransaction = Accountingtransaction.new
          accountingtransaction.account_id = account_id
          accountingtransaction.amount = amount
          accountingtransaction.trans_type =  trans_type
          accountingtransaction.policy_id = pol_id
          if ppt_id != 'none'
            accountingtransaction.policypremiumtransaction_id = ppt_id
          end
          accountingtransaction.reconcile_flag = reconcile_flag
          accountingtransaction.save
        end
      else # debit - no danger here
        accountingtransaction = Accountingtransaction.new
        accountingtransaction.account_id = account_id
        accountingtransaction.amount = amount
        accountingtransaction.trans_type =  trans_type
        accountingtransaction.policy_id = pol_id
        if ppt_id != 'none'
          accountingtransaction.policypremiumtransaction_id = ppt_id
        end
        accountingtransaction.reconcile_flag = reconcile_flag
        accountingtransaction.save
      end
    end

  end
end

