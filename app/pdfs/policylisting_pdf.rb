class PolicylistingPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(pollist, startdate, enddate)


    super(top_margin: 25, :page_layout => :landscape)
    @pollist = pollist

    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Policy Transaction Report", :align => :left, :size => 15
      text startdate + " - " + enddate
      stroke_horizontal_rule
      move_down(10)
    end

    table line_items  do |tbl|
      tbl.width = 720
      tbl.cells.padding = 2
      tbl.row_colors = ["DDDDDD", "FFFFFF"]
      tbl.header = true
      tbl.columns(0..7).style( :align=>:center,  :borders => [:left, :right, :bottom, :top], :size =>10)
    end
    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 25, 0], :align => :right, :size => 9 }
  end



  def line_items
    basepremiumtotal = 0
    feestotal = 0
    totalpremiumtotal = 0
    policycount = 0

    @pollist.each do |pl|
      policycount = policycount +1
      if !pl.base_premium.nil?
        basepremiumtotal = basepremiumtotal + pl.base_premium
      end

      if pl.fees.nil?
        tempfee = 0
      else
        tempfee = pl.fees
      end
      if pl.complexfees.nil?
        tempcomplexfee = 0
      else
        tempcomplexfee =  pl.complexfees
      end

      feestotal = feestotal +  tempfee + tempcomplexfee
      if !pl.total_premium.nil?
        totalpremiumtotal = totalpremiumtotal + pl.total_premium
      end

    end


    [["Transaction Date","Effective Date","Policy #","Carrier", "Base Premium", "Fees", "Total Premium", "Transaction"]] +
        @pollist.map do |pl|
          [

              (pl.created_at).strftime("%m/%d/%Y"),
              (pl.policy.effective_date).strftime("%m/%d/%Y"),
              pl.policy.policy_number,
              pl.policy.carrier.carrier_name,
              number_to_currency(pl.base_premium,  :negative_format => "(%u%n)"),
              (

              if pl.fees.nil?
                tempfee = 0
              else
                tempfee = pl.fees
              end
              if pl.complexfees.nil?
                tempcomplexfee = 0
              else
                tempcomplexfee =  pl.complexfees
              end



              number_to_currency((tempfee + tempcomplexfee) ,  :negative_format => "(%u%n)")

              ) ,
              number_to_currency(pl.total_premium,  :negative_format => "(%u%n)"),
              pl.transaction_type
          ]

        end +
        [["Count: "+ policycount.to_s,"","","", number_to_currency(basepremiumtotal,  :negative_format => "(%u%n)"), number_to_currency(feestotal,  :negative_format => "(%u%n)") , number_to_currency(totalpremiumtotal,  :negative_format => "(%u%n)"), ""]]
  end



end
