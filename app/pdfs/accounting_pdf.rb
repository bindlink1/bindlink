class AccountingPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(transactions, startdate, enddate)


    super(top_margin: 25, :page_layout => :landscape)
    @transactions = transactions

    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Accounting Transaction Report", :align => :left, :size => 15
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
    debittotal = 0
    credittotal= 0

    @transactions.each do |t|
      if t.trans_type == "Debit"
       debittotal = debittotal + t.amount
      else
       credittotal= credittotal + t.amount
      end
    end


    [["Transaction Date","Account","Policy #","Carrier", "Debit", "Credit"]] +
        @transactions.map do |t|
          [

              (t.created_at).strftime("%m/%d/%Y"),
              t.account_id,
              t.policy.policy_number,
              t.policy.carrier.carrier_name,

              if t.trans_type == "Debit"
               number_to_currency(t.amount,  :negative_format => "(%u%n)")
              end, if t.trans_type == "Credit"
                   number_to_currency(t.amount,  :negative_format => "(%u%n)")
                   end
=begin              (

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
=end
          ]

        end +  [["TOTALS: ","","","", number_to_currency(debittotal,  :negative_format => "(%u%n)"),number_to_currency(credittotal,  :negative_format => "(%u%n)")]]
  end



end
