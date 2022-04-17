class Fslsodata < ActiveRecord::Base


  def createreport

      @ppt = Policypremiumtransaction.find_by_sql(["SELECT pol.id as pid, pol.policy_number as pnum, pol.effective_date as eff_date, pol.expiration_date as exp_date, ppt.created_at as issue_date, pol.lineofbusiness_id as coverage_code, ppt.transaction_type as transaction_type, ppt.base_premium as base, ppt.complexfees as fees, ppt.total_premium as total,  ppt.created_at as createdon  FROM policypremiumtransactions ppt INNER JOIN policies pol ON ppt.policy_id = pol.id where pol.generalagency_id =? AND (date_trunc('day',ppt.created_at - interval '5 hours')) >= ? AND (date_trunc('day',ppt.created_at - interval '5 hours')) <= ?", 1, Date.today - 1.days, Date.today + 1.days])

      @ppt.each do |trans|
        @fslso = Fslsodata.new
        @policy = Policy.find(trans.pid)
        @fslso.policy_number = trans.pnum
        @fslso.insured_name = begin @policy.namedinsured.named_insured rescue "namedinsured" end
        @fslso.postal_code = begin @policy.namedinsured.zip rescue "postalcode" end
        @fslso.insurer_name = @policy.carrier.carrier_name
        @fslso.naic_number = @policy.carrier.naic_number
        @fslso.effective_date = trans.eff_date
        @fslso.expiration_date = trans.exp_date
        @fslso.issue_date = trans.issue_date
        @fslso.coverage_code = trans.coverage_code
        @fslso.transaction_type = trans.transaction_type
        @fslso.premium = trans.base
        @fslso.policy_fee =
        @fslso.save
      end


  end
end
