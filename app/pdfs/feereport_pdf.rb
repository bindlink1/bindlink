class FeereportPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(fee)
    super(top_margin: 25)
    @fee= fee
   # @cashtotal = cashtotal
      move_down(10)

  table line_items  do
    row(0).font_style = :bold
    columns(1..3).align = :center
    self.row_colors = ["DDDDDD", "FFFFFF"]
    self.header = true
  end
    move_down(5)
      text "Total Cash: #{number_to_currency(cashtotal)}", :size => 16, :style => :bold

 end



  def line_items


      [["Policy #", "Entered At", "Amount","Check #","Type" ]] +
      @fee.map do  |csh|
     [

     ]


      end
 end



end
