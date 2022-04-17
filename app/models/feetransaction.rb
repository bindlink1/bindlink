class Feetransaction < ActiveRecord::Base
  after_save :accountingprocess
  belongs_to :lobfee
  belongs_to :fee
  belongs_to :policypremiumtransaction
  has_one :policy, :through=> :policypremiumtransaction


  attr_accessible :fee_amount, :fee_id

  def accountingprocess

    if self.policypremiumtransaction.transaction_type == "New"  &&   !self.fee_amount.nil?
      @accountingtransactions = Accountingtransaction.new

      if self.fee.fee_remit_type == "Revenue"
        @accountingtransactions.account_id = 30002
      else
        @accountingtransactions.account_id = 20003
      end

      @accountingtransactions.amount = self.fee_amount
      @accountingtransactions.policy_id = self.policypremiumtransaction.policy.id
      @accountingtransactions.policypremiumtransaction_id = self.policypremiumtransaction_id
      @accountingtransactions.trans_type = "Credit"
      @accountingtransactions.save
    elsif self.policypremiumtransaction.transaction_type == "Renew"  &&   !self.fee_amount.nil?
      @accountingtransactions = Accountingtransaction.new

      if self.fee.fee_remit_type == "Revenue"
        @accountingtransactions.account_id = 30002
      else
        @accountingtransactions.account_id = 20003
      end

      @accountingtransactions.amount = self.fee_amount
      @accountingtransactions.policy_id = self.policypremiumtransaction.policy.id
      @accountingtransactions.policypremiumtransaction_id = self.policypremiumtransaction_id
      @accountingtransactions.trans_type = "Credit"
      @accountingtransactions.save

    elsif self.policypremiumtransaction.transaction_type == "Endorse"  &&   !self.fee_amount.nil?
      @accountingtransactions = Accountingtransaction.new

      if self.fee.fee_remit_type == "Revenue"
        @accountingtransactions.account_id = 30002
      else
        @accountingtransactions.account_id = 20003
      end

      @accountingtransactions.amount = self.fee_amount
      @accountingtransactions.policy_id = self.policypremiumtransaction.policy.id
      @accountingtransactions.policypremiumtransaction_id = self.policypremiumtransaction_id
      @accountingtransactions.trans_type = "Credit"
      @accountingtransactions.save



    elsif self.policypremiumtransaction.transaction_type == "Return Premium"  &&   !self.fee_amount.nil?
      @accountingtransactions = Accountingtransaction.new

      if self.fee.fee_remit_type == "Revenue"
        @accountingtransactions.account_id = 30002
      else
        @accountingtransactions.account_id = 20003
      end

      @accountingtransactions.amount = (self.fee_amount * -1)
      @accountingtransactions.policy_id = self.policypremiumtransaction.policy.id
      @accountingtransactions.policypremiumtransaction_id = self.policypremiumtransaction_id
      @accountingtransactions.trans_type = "Debit"
      @accountingtransactions.save


    elsif self.policypremiumtransaction.transaction_type == "Cancel" or self.policypremiumtransaction.transaction_type == "Flat Cancel"  &&   !self.fee_amount.nil?
      @accountingtransactions = Accountingtransaction.new

      if self.fee.fee_remit_type == "Revenue"
        @accountingtransactions.account_id = 30002
      else
        @accountingtransactions.account_id = 20003
      end

      @accountingtransactions.amount = (self.fee_amount * -1)
      @accountingtransactions.policy_id = self.policypremiumtransaction.policy.id
      @accountingtransactions.policypremiumtransaction_id = self.policypremiumtransaction_id
      @accountingtransactions.trans_type = "Debit"
      @accountingtransactions.save

    end


  end

  def feereport(agencyid)

    @fees = Feetransaction.joins(:policypremiumtransaction, :policy).where("policies.generalagency_id = ?", agencyid)


  end

end
