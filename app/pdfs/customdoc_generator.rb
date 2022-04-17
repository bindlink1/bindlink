class CustomdocGenerator < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(customdocs, generalagency_id, policy)
    super(:template=> "#{Rails.root}/app/pdfs/customdocs/#{customdocs.file_name}",top_margin: 25)


    #loop through fields for customdoc

    customdocs.customdocumentfields.each do |cdf|

      if !cdf.field_model.nil?
        if cdf.field_model == customdocs.document_model
          assoc = customdocs.document_model + "." + cdf.attribute_name
        else
          assoc = customdocs.document_model + "." +  cdf.field_model + "." +  cdf.field_name
        end
        if cdf.field_type == "currency"
          text_box("#{number_to_currency(eval(assoc),  :negative_format => "(%u%n)")}", :at=>[cdf.location_x.to_i,cdf.location_y.to_i])
        elsif cdf.field_type == "date"
          text_box("#{eval(assoc).strftime("%m/%d/%Y")}", :at=>[cdf.location_x.to_i,cdf.location_y.to_i])
        else
          text_box("#{eval(assoc)}", :at=>[cdf.location_x.to_i,cdf.location_y.to_i])
        end
      elsif cdf.field_type == "dateformula"
        text_box(Time.now.in_time_zone('EST').strftime("%m/%d/%Y"), :at=>[cdf.location_x.to_i,cdf.location_y.to_i])
      else
        text_box("#{cdf.attribute_name}", :at=>[cdf.location_x.to_i,cdf.location_y.to_i])

      end
    end
    customdocs.customdocumentfieldrepeats.each do |cdfr|
      assoc = customdocs.document_model + "." + cdfr.field_model
      y = cdfr.location_y
      x = cdfr.location_x
      eval(assoc).each do  |repeats|

        val = "repeats." + cdfr.field_name

        titleval = "repeats." + cdfr.title_model + "." + cdfr.title_name

        text_box("#{eval(titleval)}", :at=>[x-150,y])

        if cdfr.field_type == "currency"
          text_box("#{number_to_currency(eval(val),  :negative_format => "(%u%n)")}", :at=>[x,y])
        elsif cdfr.field_type == "date"
          text_box("#{eval(val).strftime("%m/%d/%Y")}", :at=>[x,y])
        else
          text_box("#{eval(val)}", :at=>[x,y])
        end

        #at default font size, this is an acceptable new line space
        y = y + 20


      end

    end

  end



end
