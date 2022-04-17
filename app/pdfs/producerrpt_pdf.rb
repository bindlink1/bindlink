class ProducerrptPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize( producers )
    super( top_margin: 25 )
    #super(top_margin: 25 , :page_layout => :landscape)

    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      font "Helvetica"
      text "Producing Agency Report", :align => :left, :size => 15
      stroke_horizontal_rule
      move_down(10)
    end

    table line_items( producers ) do
      self.width = 540
      row(0).font_style = :bold
      columns(0..3).style( :align=>:center,  :borders => [:left, :right, :bottom, :top], :size => 9 )
      columns(0).style( :width=>40 )
      columns(1).style( :width=>235 )
      columns(1).style( :align=>:left )
      columns(4..5).style( :align=>:right,  :borders => [:left, :right, :bottom, :top], :size => 9, :width => 62 )
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end

    number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 50, 0], :align => :right, :size => 9 }

    self.render_file "producerrpt.pdf"
  end


  def line_items(producer)
    [["ID", "Agency Name", "# of Active Policies YTD", "# of Submissions YTD", "Active Premium", "Balance Open"]] +
      producer.map do |p|
        [
            p['id'],
            p['agency_name'],
            p['policy_count'],
            p['submission_count'],
            "#{number_to_currency(p['active_premium'])}",
            "#{number_to_currency(p['balance_open'])}",
        ]
      end
  end
end