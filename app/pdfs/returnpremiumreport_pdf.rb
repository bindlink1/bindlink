class ReturnpremiumreportPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(returnpremiums)
    super(top_margin: 25 , :page_layout => :landscape)
    @returnpremiums= returnpremiums

    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Return Premium Report", :align => :left, :size => 15
      stroke_horizontal_rule
      move_down(10)
    end

      table returnpremtable  do
        self.width = 720
        row(0).font_style = :bold
        columns(0..6).style( :align=>:center,  :borders => [:left, :right, :bottom, :top], :size => 9)
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end

    move_down(10)


    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 25, 0], :align => :right, :size => 9 }
  end



  def returnpremtable

    [["Producing Agency","Policy Number","Expiration Date", "Carrier","Status","Balance" ]] +
        @returnpremiums.map do |pol|
          [

              pol.producingagency.agency_name,
              pol.policy_number,
              pol.expiration_date.strftime("%m/%d/%Y"),
              pol.carrier.carrier_name,
              pol.status,
              "#{number_to_currency(pol.policybalance)}"
          ]

        end


  end



end
