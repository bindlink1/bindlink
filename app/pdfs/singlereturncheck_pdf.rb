class SinglereturncheckPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper


  def initialize(returncheck)

    item = returncheck

    super(top_margin: 0)


            @cents = (( item.cash_amount - item.cash_amount.to_i) * -100).to_i

      draw_text "#{item.created_at.strftime("%m/%d/%Y")}" ,
                :at => [470, 700]

      if item.pfc_id.nil? == false
        draw_text "#{item.pfc.pfc_name}" ,
                  :at => [30, 660]
        draw_text "#{item.pfc.pfc_name}" ,
                  :at => [30, 600]
        draw_text "#{item.pfc.address}" ,
                  :at => [30, 590]
        if !item.pfc.address_2.blank?
          draw_text "#{item.pfc.address_2}" ,
                    :at => [30, 580]
          draw_text "#{item.pfc.city}, #{item.pfc.state} #{item.pfc.zip}" ,
                    :at => [30, 570]
        else
          draw_text "#{item.pfc.city}, #{item.pfc.state} #{item.pfc.zip}" ,
                    :at => [30, 580]
        end
      else
        draw_text "#{item.producingagency.agency_name}" ,
                  :at => [30, 660]
        draw_text "#{item.producingagency.agency_name}" ,
                  :at => [30, 600]
        draw_text "#{item.producingagency.address_1}" ,
                  :at => [30, 590]
        if !item.producingagency.address_2.blank?
          draw_text "#{item.producingagency.address_2}" ,
                    :at => [30, 580]
          draw_text "#{item.producingagency.city}, #{item.producingagency.state} #{item.producingagency.zip}" ,
                    :at => [30, 570]
        else
          draw_text "#{item.producingagency.city}, #{item.producingagency.state} #{item.producingagency.zip}" ,
                    :at => [30, 580]
        end
      end

      draw_text "#{item.cash_amount.to_i.to_words.upcase + ' AND ' + @cents.to_s + '/100'}" ,
                :at => [30, 620]
      draw_text "#{number_to_currency((item.cash_amount*-1), :unit =>'') }" ,
                :at => [475, 660]

      draw_text "#{'Policy # ' + item.policy.policy_number}" ,
                :at => [30, 550]




  end




end