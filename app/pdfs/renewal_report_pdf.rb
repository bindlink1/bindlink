class RenewalReportPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize( r, startdate, enddate, lob )
    super(top_margin: 25 , :page_layout => :landscape)
    #@r = r
    #@startdate = startdate
    #@enddate = enddate
    #@atype = atype

    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Policy Reneqal Report", :align => :left, :size => 15
      text "Start Date: #{startdate.strftime("%m/%d/%Y")}"
      text "End Date: #{enddate.strftime("%m/%d/%Y")}"
      text "Line of Business: #{lob}"
      text "Status: Active"
      stroke_horizontal_rule
      move_down(10)
    end

    if !r.empty? then
      move_down(10)
      table line_items( r ) do
        row(0).font_style = :bold
        #columns(1..3).align = :center
        cells.size = 10
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
    end
    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 25, 0], :align => :right, :size => 9 }
  end


  def line_items( r )
    [["Client", "Policy Number", "Expiration Date", "Carrier", "Line of Business", "Annual Premium", "Nonrenew"]] +
        r.map do |p|
          [
              p.namedinsured.named_insured,
              p.policy_number,
              p.expiration_date.strftime("%m/%d/%Y"),
              p.carrier.carrier_name,
              p.lineofbusiness.line_name,
              "#{number_to_currency(p.annualpremium)}",
             begin p.is_nonrenew.to_s rescue '' end

          ]
        end
  end
end
