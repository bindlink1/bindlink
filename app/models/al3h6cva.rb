class Al3h6cva < ActiveRecord::Base
  belongs_to :al3h5veh
  belongs_to :al3h5lag
    def process(algroup, vehid, lagid)
    al6cva = Al3h6cva.new
    al6cva.al3h5veh_id = vehid
    al6cva.al3h5lag_id = lagid
    al6cva.header = algroup[0..29]
    al6cva.coverage_code = algroup[30..34]
    al6cva.form_number = algroup[86..95]
    al6cva.limit1 = algroup[102..109]
    al6cva.limit2 = algroup[110..117]
    al6cva.deductible = algroup[118..123]
    al6cva.deductible_type_code = algroup[139..140]
    al6cva.save
    end


   def autocoverages(al3h5lag_id)

     covs = Al3h6cva.select("coverage_code,limit1, limit2,deductible, deductible_type_code ").where("coverage_code <> 'COMP' AND coverage_code <> 'COLL' AND limit1 >0  ").group("coverage_code,limit1, limit2,deductible, deductible_type_code").find_all_by_al3h5lag_id(al3h5lag_id)

     covs
   end




end
