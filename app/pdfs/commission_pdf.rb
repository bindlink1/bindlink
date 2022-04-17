class CommissionPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(commissionrev,commissionexp, revenuetotal, revenuenew,revenueendorse, revenuecancel, revenuereinstate, revenuereturn,expensetotal, expensenew,expenseendorse, expensecancel, expensereinstate, expensereturn, startdate, enddate, premiumnew, premiumrenew, premiumreinstate, premiumcancel, premiumendorse, premiumreturn, premiumtotal, unearned, unearnednew, unearnedendorse, unearnedcancel, unearnedreinstate, unearnedreturn, unearnedtotal,  counttotal, countnew, countendorse, countcancel, countreinstate, countreturn, revenuerenew, unearnedrenew, countrenew, datetype, agencytype )

    super(top_margin: 25, :page_layout => :landscape)
    @commissionrev = commissionrev
    @commissionexp = commissionexp
    @revenuetotal = revenuetotal
    @revenuenew = revenuenew
    @revenueendorse = revenueendorse
    @revenuecancel = revenuecancel
    @revenuereinstate = revenuereinstate
    @revenuereturn = revenuereturn
    @expensetotal = expensetotal
    @expensenew = expensenew
    @expenseendorse = expenseendorse
    @expensecancel = expensecancel
    @expensereinstate = expensereinstate
    @expensereturn = expensereturn
    @premiumnew = premiumnew
    @premiumrenew = premiumrenew
    @premiumreinstate = premiumreinstate
    @premiumcancel = premiumcancel
    @premiumendorse = premiumendorse
    @premiumreturn = premiumreturn
    @premiumtotal = premiumtotal
    @unearned = unearned
    @unearnednew = unearnednew
    @unearnedendorse = unearnedendorse
    @unearnedcancel = unearnedcancel
    @unearnedreinstate = unearnedreinstate
    @unearnedreturn = unearnedreturn
    @unearnedtotal = unearnedtotal
    @revenuerenew = revenuerenew
    @unearnedrenew = unearnedrenew
    @countrenew = countrenew
    @counttotal = counttotal
    @countnew = countnew
    @countendorse = countendorse
    @countcancel = countcancel
    @countreinstate = countreinstate
    @countreturn = countreturn
    @datetype = datetype
    @agencytype = agencytype

    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Commission Report", :align => :left, :size => 15
      text startdate + " - " + enddate
      text "Date Type Selected: #{@datetype}", :align => :left
      stroke_horizontal_rule
      move_down(10)
    end


    move_down(10)
    bounding_box([0,500], :width => 600) do
      text "Summary"
      table revenue_summary do |tbl|
        tbl.width = 600
        tbl.cells.padding = 5
        tbl.row_colors = ["DDDDDD", "FFFFFF"]
        tbl.header = true
        tbl.columns(0..1).style( :align=>:left,  :borders => [:left, :right, :bottom, :top], :size =>9)
      end
    end



    move_down(10)
    stroke_horizontal_rule
    move_down(10)
    text "Earned Commission Detail"
    move_down(10)
    table commission_revenue do |tbl|
      tbl.width = 720
      tbl.cells.padding = 1
      tbl.row_colors = ["DDDDDD", "FFFFFF"]
      tbl.header = true
      tbl.columns(0..7).style( :align=>:left,  :borders => [:left, :right, :bottom, :top], :size =>9)
    end

    if !@unearned.blank?
      move_down(10)
      stroke_horizontal_rule
      move_down(10)
      text "Unearned Detail"
      move_down(10)

      table unearned_commission do |tbl|
        tbl.width = 720
        tbl.cells.padding = 1
        tbl.row_colors = ["DDDDDD", "FFFFFF"]
        tbl.header = true
        tbl.columns(0..7).style( :align=>:left,  :borders => [:left, :right, :bottom, :top], :size =>9)

      end

    end

    if !@commissionexp.blank?
      start_new_page(top_margin: 25)

      text "Commission Expense Summary"
      table expense_summary do |tbl|
        tbl.width = 300
        tbl.cells.padding = 5
        tbl.row_colors = ["DDDDDD", "FFFFFF"]
        tbl.header = true
        tbl.columns(0..1).style( :align=>:left,  :borders => [:left, :right, :bottom, :top], :size =>9)
      end
      move_down(10)

      text "Commission Expense Detail"
      table commission_expense do |tbl|
        tbl.width = 720
        tbl.cells.padding = 2
        tbl.row_colors = ["DDDDDD", "FFFFFF"]
        tbl.header = true
        tbl.columns(0..7).style( :align=>:center,  :borders => [:left, :right, :bottom, :top], :size =>9)
      end
    end
    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 40, 0], :align => :right, :size => 9 }
  end

  def revenue_summary
    revenuesummary = []
    revenuesummary << ["Transaction Type","Total Premium", "Count" ,"Earned", "Unearned"]

    revenuesummary << ["New"," #{number_to_currency(@premiumnew,  :negative_format => "(%u%n)")}" , "#{@countnew}", " #{number_to_currency(@revenuenew,  :negative_format => "(%u%n)")}", " #{number_to_currency(@unearnednew,  :negative_format => "(%u%n)")}"]
    revenuesummary << ["Renew"," #{number_to_currency(@premiumrenew,  :negative_format => "(%u%n)")}" , "#{@countrenew}", " #{number_to_currency(@revenuerenew,  :negative_format => "(%u%n)")}", " #{number_to_currency(@unearnedrenew,  :negative_format => "(%u%n)")}"]
    revenuesummary << ["Endorse"," #{number_to_currency(@premiumendorse,  :negative_format => "(%u%n)")}" , "#{@countendorse}", " #{number_to_currency(@revenueendorse,  :negative_format => "(%u%n)")}", " #{number_to_currency(@unearnedendorse,  :negative_format => "(%u%n)")}"]
    revenuesummary << ["Cancel"," #{number_to_currency(@premiumcancel,  :negative_format => "(%u%n)")}", "#{@countcancel}", " #{number_to_currency(@revenuecancel,  :negative_format => "(%u%n)")}", " #{number_to_currency(@unearnedcancel,  :negative_format => "(%u%n)")}"]
    revenuesummary << ["Reinstate"," #{number_to_currency(@premiumreinstate,  :negative_format => "(%u%n)")}", "#{@countreinstate}", " #{number_to_currency(@revenuereinstate,  :negative_format => "(%u%n)")}", " #{number_to_currency(@unearnedreinstate,  :negative_format => "(%u%n)")}"]
    revenuesummary << ["Return Premium"," #{number_to_currency(@premiumreturn,  :negative_format => "(%u%n)")}", "#{@countreturn}", " #{number_to_currency(@revenuereturn,  :negative_format => "(%u%n)")}", " #{number_to_currency(@unearnedreturn,  :negative_format => "(%u%n)")}"]
    revenuesummary << ["Total"," #{number_to_currency(@premiumtotal,  :negative_format => "(%u%n)")}", "#{@counttotal}", " #{number_to_currency(@revenuetotal,  :negative_format => "(%u%n)")}" ," #{number_to_currency(@unearnedtotal,  :negative_format => "(%u%n)")}"]
  end

  def expense_summary
    expensesummary = []
    expensesummary << ["Transaction Type",""]

    expensesummary << ["New / Renew", " #{number_to_currency(@expensenew,  :negative_format => "(%u%n)")}"]
    expensesummary << ["Endorse", " #{number_to_currency(@expenseendorse,  :negative_format => "(%u%n)")}"]
    expensesummary << ["Cancel", " #{number_to_currency(@expensecancel,  :negative_format => "(%u%n)")}"]
    expensesummary << ["Reinstate", " #{number_to_currency(@expensereinstate,  :negative_format => "(%u%n)")}"]
    expensesummary << ["Return Premium", " #{number_to_currency(@expensereturn,  :negative_format => "(%u%n)")}"]
    expensesummary << ["Total", " #{number_to_currency(@expensetotal,  :negative_format => "(%u%n)")}"]
  end

  def commission_revenue
    if @agencytype == "Retail"
      tableheader = ["Transaction Date", "Effective Date","Policy Number", "Carrier","Location", "Transaction Type","Total Premium","Earned Commission"]
      [tableheader] +
          @commissionrev.map do |rd|
            [
                (rd.book_date).strftime("%m/%d/%Y"),
                begin(rd.transaction_effective_date).strftime("%m/%d/%Y")rescue "" end,
                begin rd.policy.policy_number rescue "" end,
                begin rd.policy.carrier.carrier_name rescue "" end,
                begin rd.policy.client.location.location_nickname rescue "" end,
                begin rd.policypremiumtransaction.transaction_type rescue "Journal Entry" end,
                begin number_to_currency(rd.policypremiumtransaction.total_premium,  :negative_format => "(%u%n)") rescue "" end,
                if rd.trans_type == "Credit"
                  number_to_currency(rd.amount,  :negative_format => "(%u%n)")
                else
                  number_to_currency(rd.amount * -1,  :negative_format => "(%u%n)")
                end
            ]
          end
    else
      tableheader = ["Transaction Date", "Effective Date","Policy Number", "Carrier","Location", "Transaction Type","Total Premium","Producing Agency", "Earned Commission"]



    [tableheader] +
        @commissionrev.map do |rd|
          [
              (rd.book_date).strftime("%m/%d/%Y"),
              begin(rd.transaction_effective_date).strftime("%m/%d/%Y")rescue "" end,
              begin rd.policy.policy_number rescue "" end,
              begin rd.policy.carrier.carrier_name rescue "" end,
              begin rd.policy.client.location.location_nickname rescue "" end,
              begin rd.transaction_type rescue "Journal Entry" end,
              begin number_to_currency(rd.policypremiumtransaction.total_premium,  :negative_format => "(%u%n)") rescue "" end,
              begin rd.policy.producingagency.agency_name rescue "" end,
              if rd.trans_type == "Credit"
                number_to_currency(rd.amount,  :negative_format => "(%u%n)")
              else
                number_to_currency(rd.amount * -1,  :negative_format => "(%u%n)")
              end
          ]
          end
    end
  end

  def unearned_commission

    [["Transaction Date","Effective Date","Policy Number", "Carrier","Location", "Transaction Type","Total Premium","Unearned Commission"]] +
        @unearned.map do |rd|

          [

              (rd.book_date).strftime("%m/%d/%Y"),
              begin (rd.transaction_effective_date).strftime("%m/%d/%Y")rescue "" end,
              begin rd.policy.policy_number rescue "" end,
              begin rd.policy.carrier.carrier_name rescue "" end,
              begin rd.policy.client.location.location_nickname rescue "" end,
              begin rd.transaction_type rescue "Journal Entry" end,
              begin number_to_currency(rd.policypremiumtransaction.total_premium,  :negative_format => "(%u%n)") rescue "" end,
              begin rd.policy.producingagency.agency_name rescue "" end,
              if rd.trans_type == "Credit"
                number_to_currency(rd.amount,  :negative_format => "(%u%n)")
              else
                number_to_currency(rd.amount * -1,  :negative_format => "(%u%n)")
              end

          ]

        end
  end



  def commission_expense
    [["Transaction Date","Effective Date","Policy Number", "Carrier", "Transaction Type", "Producing Agency" , "Commission"]] +
        @commissionexp.map do |rd|
          [
              (rd.book_date).strftime("%m/%d/%Y"),
              begin (rd.transaction_effective_date).strftime("%m/%d/%Y")rescue "" end,
              begin rd.policy.policy_number rescue "" end,
              begin rd.policy.carrier.carrier_name rescue "" end,
              begin rd.transaction_type rescue "Journal Entry" end,

              begin rd.policy.producingagency.agency_name rescue "" end,

              if rd.trans_type == "Credit"
                number_to_currency(rd.amount,  :negative_format => "(%u%n)")
              else
                number_to_currency(rd.amount * -1,  :negative_format => "(%u%n)")
              end

          ]
        end
  end
end
