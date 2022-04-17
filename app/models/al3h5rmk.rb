class Al3h5rmk < ActiveRecord::Base
    belongs_to :al3h5bpi

  def process(algroup, bpiid)
    al5rmk = Al3h5rmk.new
    al5rmk.al3h5bpi_id = bpiid
    al5rmk.header = algroup[0..29]
    al5rmk.data_element_referenced = algroup[30..31]
    al5rmk.remarks_number = algroup[32..33]
    al5rmk.remarks_impact_indicator = algroup[34..34]
    al5rmk.remarks_text = algroup[35..194]
    al5rmk.save
  end
end
