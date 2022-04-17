class AcordPdf90fl < Prawn::Document

  def initialize(client)
    super(:template=> "#{Rails.root}/app/pdfs/90_fl.pdf",top_margin: 25)
    @client = client
    go_to_page(1)
    font_size(8)

    bounding_box([478,715], :width => 200, :height => 75) do
      appdate
    end

    bounding_box([214,687], :width => 200, :height => 75) do
      insuredinfo
    end

  end

  def insuredinfo
    text "#{@client.first_name} #{@client.last_name} "

  end

  def appdate
    text "#{Date.today.strftime("%m/%d/%Y")}"
  end



end
