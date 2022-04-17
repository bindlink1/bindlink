class AcordPdf < Prawn::Document
  def initialize(policy)
    super(:template=> "#{Rails.root}/app/pdfs/acord25.pdf",top_margin: 25)

    @policy = policy
    move_down(32)
    text "#{@policy.agency.agency_name}"
    text "#{@policy.agency.address_1}"
    text "#{@policy.agency.city}, #{@policy.agency.state} #{@policy.agency.zip}"

    move_down(20)
    text "#{@policy.client.client_name} "
    text "#{@policy.client.address_1} #{@policy.client.address2}"
    text "#{@policy.client.city} ,#{@policy.client.state} #{@policy.client.zip} "

    insurers
    todaysdate
    typecheckbox
    policyinfo
  end

  def insurers

  text_box("#{@policy.carrier.carrier_name}", :at=>[315,645])


  end

  def todaysdate

   text_box("#{Date.today.strftime("%m/%d/%Y")}", :at=>[475,720])

  end

  def typecheckbox
   text_box("X", :at=>[20,515])
   text_box("X", :at=>[100,500])


  end

  def policyinfo
     text_box("#{@policy.policy_number}", :at=>[145,520])
     text_box("#{@policy.effective_date.strftime("%m/%d/%Y")}", :at=>[260,520])
     text_box("#{@policy.expiration_date.strftime("%m/%d/%Y")}", :at=>[325,520])
  end


end
