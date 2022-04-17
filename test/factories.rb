FactoryGirl.define do


  factory :policy do
    id 100
    generalagency_id 1
    producingagency_id 80
    payment_type_id 1
    sequence(:policy_number) { |n| "TESTPOLICY#{n}" }
    status 'Active'
    state 'FL'
    effective_date '2012/12/12'
    carrier_id  100
    lineofbusiness_id 5

  end

  factory :policypremiumtransaction do
    id 1
    policy_id 100
    base_premium 1000
    fees 250
    complexfees 250
    total_premium 1250
    transaction_type 'New'
    book_date '2012/12/12'
    transaction_effective_date '2012/12/12'

  end

  factory :feeforwarddata do
    policypremiumtransaction_id 1
    fee_amount 10
    fee_id 1
  end
  factory :feerevenuedata do
    policypremiumtransaction_id 1
    fee_amount 5
    fee_id 2
  end

  factory :feeforward do
    id 1
    fee_remit_type "Forward"
    earn_type "Pro Rata"
    attach_type "Always"
  end

  factory :feeforward do
    id 2
    fee_remit_type "Revenue"
    earn_type "Fully Earned"
    attach_type "New/Renew"
  end

  factory :carrier do
    id 100
    carrier_name 'Worldwide Insurance'
    generalagency_id 1

  end

  factory :carrierlob do
    lineofbusiness_id 100
    carrier_id 100
    id 100

  end

  factory :lineofbusiness do
    id 100

    agency_id 1
    line_name 'TEST LOB'
  end

  factory :lobcommission do

    agency_id 1
    state 'FL'
    commission_rate 0.15
    billing_type 5
    carrierlob_id 100

  end

end