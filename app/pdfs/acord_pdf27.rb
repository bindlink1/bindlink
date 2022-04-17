class AcordPdf27 < Prawn::Document
  def initialize(policy)
    super(:template=> "#{Rails.root}/app/pdfs/acord27.pdf",top_margin: 25)

    @policy = policy
    move_down(70)
    agencyinfo

    move_down(50)
    insuredinfo

    insurers
    todaysdate
    policyinfo
    propertyinfo
    coverage
  end

  def agencyinfo
    text "#{@policy.agency.agency_name}"
    text "#{@policy.agency.address_1}"
    text "#{@policy.agency.city}, #{@policy.agency.state} #{@policy.agency.zip}"
    text_box("#{@policy.agency.telephone}", :at=>[140,675])
  end

  def insuredinfo
    text "#{@policy.client.client_name} "
    text "#{@policy.client.address_1} #{@policy.client.address2}"
    text "#{@policy.client.city} ,#{@policy.client.state} #{@policy.client.zip} "
  end

  def propertyinfo

    text_box("#{@policy.client.address_1} #{@policy.client.address2} #{@policy.client.city} ,#{@policy.client.state} #{@policy.client.zip}" , :at=>[0,485])

    #text "#{@policy.client.city} ,#{@policy.client.state} #{@policy.client.zip} "
  end


  def insurers

  text_box("#{@policy.carrier.carrier_name}", :at=>[315,645])


  end

  def todaysdate

   text_box("#{Date.today.strftime("%m/%d/%Y")}", :at=>[475,720])

  end



  def policyinfo
     text_box("#{@policy.policy_number}", :at=>[375,570])
     text_box("#{@policy.effective_date.strftime("%m/%d/%Y")}", :at=>[285,545])
     text_box("#{@policy.expiration_date.strftime("%m/%d/%Y")}", :at=>[370,545])
  end

  def coverage
    text_box("#{@policy.lineofbusiness.line_name}", :at=>[0,365])


  end

end
