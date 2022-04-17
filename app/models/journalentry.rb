class Journalentry < ActiveRecord::Base
  belongs_to :accountingaccount
  belongs_to :policy
  attr_accessible :accountingaccount_id, :trans_type, :amount, :policy_id


  def process
    accountingtransaction = Accountingtransaction.new
    accountingtransaction.account_id = self.accountingaccount.account_id
    accountingtransaction.amount = self.amount
    accountingtransaction.trans_type =  self.trans_type
    accountingtransaction.policy_id = self.policy_id

    accountingtransaction.save
  end

end
