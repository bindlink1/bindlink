class SinglecompaycheckPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper


  def initialize(compaycheck)

    @compaycheck = compaycheck

    super(top_margin: 0)


      @cents = (( @compaycheck.cash_amount - @compaycheck.cash_amount.to_i) * -100).to_i

      draw_text "#{@compaycheck.created_at.strftime("%m/%d/%Y")}" ,
                  :at => [470, 700]


        draw_text "#{@compaycheck.policy.producingagency.agency_name}" ,
                  :at => [30, 650]


      draw_text "#{@compaycheck.cash_amount.to_i.to_words.upcase + ' AND ' + @cents.to_s + '/100'}" ,
                :at => [30, 620]
      draw_text "#{number_to_currency((@compaycheck.cash_amount), :unit =>'') }" ,
                :at => [470, 650]

      draw_text "#{'Policy # ' + @compaycheck.policy.policy_number}" ,
                :at => [30, 545]



    draw_text "#{@compaycheck.policy.producingagency.agency_name}" ,
              :at => [30, 600]
    draw_text "#{@compaycheck.policy.producingagency.address_1}" ,
              :at => [30, 590]
    if !@compaycheck.policy.producingagency.address_2.blank?
      draw_text "#{@compaycheck.policy.producingagency.address_2}" ,
                :at => [30, 580]
      draw_text "#{@compaycheck.policy.producingagency.city}, #{@compaycheck.policy.producingagency.state} #{@compaycheck.policy.producingagency.zip}" ,
                :at => [30, 570]
    else
      draw_text "#{@compaycheck.policy.producingagency.city}, #{@compaycheck.policy.producingagency.state} #{@compaycheck.policy.producingagency.zip}" ,
                :at => [30, 580]
    end


  end




end