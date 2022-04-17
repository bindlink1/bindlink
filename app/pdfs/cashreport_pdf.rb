class CashreportPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(cash, cashtotal, startdate, enddate)
    super(top_margin: 25)
    @cash= cash
    @cashtotal = cashtotal

    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Cash Deposited Report", :align => :left, :size => 15
      text startdate + " - " + enddate
      stroke_horizontal_rule
      move_down(10)
    end


    table line_items  do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.width = 540
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
      self.columns(0..7).style( :align=>:center,  :borders => [:left, :right, :bottom, :top], :size => 9)
    end
    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 25, 0], :align => :right, :size => 9 }

  end



  def line_items


    [["Policy #", "Entered At","Check #", "Amount"]] +
        @cash.map do  |csh|
          [
              csh.policy.policy_number,
              csh.created_at.strftime("%m/%d/%Y %I:%M %p"),
              csh.check_number,
              number_to_currency(csh.cash_amount)

          ]
        end +
        [["","","", ""]]+
        [["Total","","", number_to_currency(@cashtotal)]]

  end



end
