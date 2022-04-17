class ReturncheckPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper


  def initialize(returnbatch)
    @returnbatch = returnbatch
    @returncount = Returnpremiumbatchitem.find_all_by_return_premium_batch_id(@returnbatch.id).count()


    super(top_margin: 0)

    @returnbatch.returnpremiumbatchitems.each_with_index do |item, index|
      @cents = (( item.cashtransaction.cash_amount - item.cashtransaction.cash_amount.to_i) * -100).to_i

      draw_text "#{item.cashtransaction.created_at.strftime("%m/%d/%Y")}" ,
                :at => [470, 700]

      if item.cashtransaction.pfc_id.nil? == false
        draw_text "#{item.cashtransaction.pfc.pfc_name}" ,
                  :at => [30, 660]
        draw_text "#{item.cashtransaction.pfc.pfc_name}" ,
                  :at => [30, 600]
        draw_text "#{item.cashtransaction.pfc.address}" ,
                  :at => [30, 590]
        if !item.cashtransaction.pfc.address_2.blank?
          draw_text "#{item.cashtransaction.pfc.address_2}" ,
                    :at => [30, 580]
          draw_text "#{item.cashtransaction.pfc.city}, #{item.cashtransaction.pfc.state} #{item.cashtransaction.pfc.zip}" ,
                    :at => [30, 570]
        else
          draw_text "#{item.cashtransaction.pfc.city}, #{item.cashtransaction.pfc.state} #{item.cashtransaction.pfc.zip}" ,
                    :at => [30, 580]
        end
      else
        draw_text "#{item.cashtransaction.producingagency.agency_name}" ,
                  :at => [30, 660]
        draw_text "#{item.cashtransaction.producingagency.agency_name}" ,
                  :at => [30, 600]
        draw_text "#{item.cashtransaction.producingagency.address_1}" ,
                  :at => [30, 590]
        if !item.cashtransaction.producingagency.address_2.blank?
          draw_text "#{item.cashtransaction.producingagency.address_2}" ,
                    :at => [30, 580]
          draw_text "#{item.cashtransaction.producingagency.city}, #{item.cashtransaction.producingagency.state} #{item.cashtransaction.producingagency.zip}" ,
                    :at => [30, 570]
        else
          draw_text "#{item.cashtransaction.producingagency.city}, #{item.cashtransaction.producingagency.state} #{item.cashtransaction.producingagency.zip}" ,
                    :at => [30, 580]
        end
      end

      draw_text "#{item.cashtransaction.cash_amount.to_i.to_words.upcase + ' AND ' + @cents.to_s + '/100'}" ,
                :at => [30, 620]
      draw_text "#{number_to_currency((item.cashtransaction.cash_amount*-1), :unit =>'') }" ,
                :at => [475, 660]

      draw_text "#{'Policy # ' + item.cashtransaction.policy.policy_number}" ,
                :at => [30, 550]

      if (index +1) < @returncount
        start_new_page(top_margin: 25)
      end

    end


  end




end