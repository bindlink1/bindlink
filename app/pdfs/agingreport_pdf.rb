class AgingreportPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(invoices30, invoices60, invoices90, invoicesover)
    super(top_margin: 25 , :page_layout => :landscape)

    @invoices30   = invoices30
    @invoices60   = invoices60
    @invoices90   = invoices90
    @invoicesover = invoicesover

    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Invoice Aging Report", :align => :left, :size => 15
      stroke_horizontal_rule
      move_down(10)
    end

    grandtotal = 0

    if !@invoices30.empty? then
      bal = 0
      @invoices30.each do |b|
        bal = bal + b.outstandingbalance
      end

      grandtotal = grandtotal + bal
      text "0 to 30 Days"
      table line_items(@invoices30)  do
        self.width = 720
        row(0).font_style = :bold
        columns(0..6).style( :align=>:center,  :borders => [:left, :right, :bottom, :top], :size => 9)
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
    end

    move_down(10)

    if !@invoices60.empty? then
      bal = 0
      
      @invoices60.each do |b|
        bal = bal + b.outstandingbalance
      end

      grandtotal = grandtotal + bal
      
      text "31 to 60 Days"

      table line_items(@invoices60)  do
        row(0).font_style = :bold
        columns(1..3).align = :center
        cells.size = 10
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
    end

    if !@invoices90.empty? then
      bal = 0

      @invoices90.each do |b|
        bal = bal + b.outstandingbalance
      end

      grandtotal = grandtotal + bal
      move_down(10)
      text "61 to 90 Days"
      table line_items(@invoices90)  do
        row(0).font_style = :bold
        columns(1..3).align = :center
        cells.size = 10
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end

    end

    if !@invoicesover.empty? then
      bal = 0
      
      @invoicesover.each do |b|
        bal = bal + b.outstandingbalance
      end

      grandtotal = grandtotal + bal
      move_down(10)
      text "Over 90 Days"
      table line_items(@invoicesover)  do
        row(0).font_style = :bold
        columns(1..3).align = :center
        cells.size = 10
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
    end

    table grandtotal(grandtotal)  do
      row(0).font_style = :bold
      columns(1..3).align = :center
      cells.size = 10
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end

    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 25, 0], :align => :right, :size => 9 }

    self.render_file "report.pdf"
  end

  def grandtotal(grandtotal)
    [[ "Grand Total", number_to_currency(grandtotal)]]
  end

  def line_items(invoice)
    result = invoice.select do |inv|
      inv.outstandingbalance >= 0.01
    end

    [["Producing Agency", "Policy", "Due On", "Carrier", "Balance", "Status", "Days Outstanding"]] +
        result.map do |inv|
          [
              ( inv.policypremiumtransaction.policy.producingagency.nil? ? "" : inv.policypremiumtransaction.policy.producingagency.agency_name ),
              inv.policypremiumtransaction.policy.policy_number,
              inv.due_on.strftime("%m/%d/%Y"),
              inv.policypremiumtransaction.policy.carrier.carrier_name,
              "#{number_to_currency(inv.outstandingbalance)}",
              inv.policypremiumtransaction.policy.status,
              inv.invoiceage,
          ]
        end
  end
end