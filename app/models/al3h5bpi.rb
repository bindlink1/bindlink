class Al3h5bpi < ActiveRecord::Base
  belongs_to :al3h5bis
  belongs_to :al3h2trg
  has_many :al3h5drvs
  has_many :al3h5lags
  has_many :al3h5rmks

  def process(algroup, trgid)
    al5bpi = Al3h5bpi.new
    al5bpi.al3h2trg_id = trgid
    al5bpi.header = algroup[0..29]
    al5bpi.policy_number  = algroup[30..54].strip
    al5bpi.company_code  = algroup[65..70].strip
    al5bpi.line_of_business_code = algroup[71..75]
    al5bpi.line_of_business_subcode = algroup[76..79]
    al5bpi.original_policy_inception_date = algroup[100..107]
    al5bpi.renewal_term = algroup[108..110]
    al5bpi.current_term_amount = (algroup[111..122].to_f / 100)
    al5bpi.net_change_amount = (algroup[123..133].to_f / 100)
    change_sign =  algroup[134..134]
    al5bpi.nominal_term_amount =  (algroup[147..158].to_f / 100)
    al5bpi.written_amount = (algroup[159..170].to_f / 100)
    if change_sign == "-"
      al5bpi.net_change_amount = al5bpi.net_change_amount * -1
    end

    al5bpi.policy_effective_date = algroup[257..264]
    al5bpi.policy_expiration_date = algroup[265..272]
    al5bpi.commission_premium = (algroup[306..317].to_f / 100)
    al5bpi.minimum_premium = (algroup[318..329].to_f / 100)
    al5bpi.save
    findcarrier(al5bpi, al5bpi.company_code)
    findpolicy(al5bpi, al5bpi.policy_number,al5bpi.policy_effective_date)

    al5bpi.id



  end

  def findpolicy(al5bpi, policy_number, effective_date)
    alt = Al3transaction.find(al5bpi.al3h2trg.al3transaction.id)

    matchcount = Policy.where("policy_number = ? AND effective_date =? ", policy_number, effective_date).find_all_by_agency_id(alt.agency_id).count()



    if matchcount == 1
      matchpolicy =   Policy.where("policy_number = ? AND effective_date =? ", policy_number, effective_date).find_all_by_agency_id(alt.agency_id).last()

      alt.policy_id = matchpolicy.id
      alt.save


    end

    matchcount
  end

  def findcarrier(al5bpi, company_code)

    carriernaic = Carriernaic.find_by_naic_number(company_code.strip)

    if !carriernaic.nil?
      alt = Al3transaction.find(al5bpi.al3h2trg.al3transaction.id)
      alt.carrier_id = carriernaic.carrier_id
      alt.save
    end

  end
end
