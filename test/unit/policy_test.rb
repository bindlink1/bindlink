require 'test_helper'

class PolicyTest < ActiveSupport::TestCase



  test "accountingbalance" do
    carrierlob =  FactoryGirl.create(:carrierlob)
    lobcommission = FactoryGirl.create(:lobcommission)
    carrier =  FactoryGirl.create(:carrier)
    lob =  FactoryGirl.create(:lineofbusiness)
    policy =  FactoryGirl.create(:policy)

    policypremiumtransaction = FactoryGirl.create(:policypremiumtransaction)
    policypremiumtransaction = FactoryGirl.create(:policypremiumtransaction, base_premium: 250, total_premium: 250, transaction_type: 'New', book_date: '2012/12/12')





    assert policy.accounting_balance == 0
  end

  test "flatcancel" do
    carrierlob =  FactoryGirl.create(:carrierlob)
    lobcommission = FactoryGirl.create(:lobcommission)
    carrier =  FactoryGirl.create(:carrier)
    lob =  FactoryGirl.create(:lineofbusiness)
    policy =  FactoryGirl.create(:policy)

    policypremiumtransaction = FactoryGirl.create(:policypremiumtransaction)
    policypremiumtransaction = FactoryGirl.create(:policypremiumtransaction, base_premium: 250, total_premium: 250, transaction_type: 'New', book_date: '2012/12/12')



    policy.flatcancel

    assert policy.accounting_balance == 0



  end
end


