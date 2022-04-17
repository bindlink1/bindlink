class Al3h5bis < ActiveRecord::Base
   belongs_to :al3h2trg
   has_one :al3h5bpi

  def process(algroup, trgid)
    al5bis = Al3h5bis.new
    al5bis.al3h2trg_id = trgid
    al5bis.header = algroup[0..29]

    al5bis.insureds_name = algroup[30..89]
    al5bis.companys_id_for_insured = algroup[90..119]
    al5bis.agencys_id_for_insured = algroup[120..149]
    al5bis.legal_entity_code = algroup[150..151]
    al5bis.number_of_member_and_managers = algroup[152..156]

    al5bis.save

    al5bis.id
  end
end
