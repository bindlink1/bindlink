class ExpiringreportPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize( expiring, startdate, enddate, atype, lobid, carrierid )
    super(top_margin: 25 , :page_layout => :landscape)
    @expiring = expiring
    @startdate = startdate
    @enddate = enddate
    @atype = atype
    if lobid != "all"
      @lob = Lineofbusiness.find(lobid)
      @lob = @lob.line_name
    else
      @lob = "All"
    end
    if carrierid != "all"
      @carrier = Carrier.find( carrierid )
      @carrier = @carrier.carrier_name
    else
      @carrier = "All"
    end
    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Policy Expiring Report", :align => :left, :size => 15
      text "Start Date: #{@startdate.strftime("%m/%d/%Y")}"
      text "End Date: #{@enddate.strftime("%m/%d/%Y")}"
      text "Line of Business: #{@lob}"
      text "Carrier: #{@carrier}"
      stroke_horizontal_rule
      move_down(10)
    end

    unless @expiring.nil? or @expiring.empty? then

      move_down(10)
      table line_items(@expiring)  do
        row(0).font_style = :bold
        columns(1..3).align = :center
        cells.size = 10
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end

    end
    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 25, 0], :align => :right, :size => 9 }
  end


  def line_items(expiring)

    #Name/policy number/ policy premium/ expiration date/ agent/

    [["Client","Policy Number","Expiration Date", "Carrier","Line of Business", "Status" ,"Annual Premium", "Nonrenew"]] +
        expiring.map do |exp|
          if @atype == "Retail"
            namedinsured = exp.client.fullname
          else
            namedinsured = exp.namedinsured.named_insured
          end
          [
              namedinsured,
              exp.policy_number,
              exp.expiration_date.strftime("%m/%d/%Y"),
              exp.carrier.carrier_name,
              exp.lineofbusiness.line_name,
              exp.status,
              "#{number_to_currency(exp.annualpremium)}",
             begin exp.is_nonrenew.to_s rescue '' end

          ]

        end

  end





end
