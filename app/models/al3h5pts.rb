class Al3h5pts < ActiveRecord::Base
  belongs_to :al3h2trg

  def process(algroup, trgid)
    al3h5pt = Al3h5pts.new
    al3h5pt.al3h2trg_id = trgid
    al3h5pt.line_number = algroup[30..32]
    al3h5pt.line_content = algroup[33..112]

    al3h5pt.save


    al3h5pt.id



  end

end
