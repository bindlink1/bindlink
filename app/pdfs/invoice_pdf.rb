class InvoicePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(invoice)
    super(top_margin: 20)
    font_size(11)
    @invoice = invoice


    if @invoice.policypremiumtransaction.policy.isga  == "GA"

    image "#{Rails.root}/app/pdfs/gic_underwriters.png",:width => 100, :height => 50

    else

    agencyinfo
    end
    move_down(10)
    bounding_box([400,720], :width => 200, :height => 75) do
      text "Invoice", :size => 20, :style => :bold
      text "Date: #{Date.today.strftime("%m/%d/%Y")}"

    end
    bounding_box([10,615], :width => 200, :height => 75) do
      insuredinfo
    end
    move_down(20)

    bounding_box([0,7], :width => 540, :height => 50, :align=>:left) do
      if @invoice.policypremiumtransaction.policy.isga == "GA"
        text "#{@invoice.policypremiumtransaction.policy.generalagency.agency_name}"
      else
        text "#{@invoice.policypremiumtransaction.policy.agency.agency_name}"
      end

    end

    bounding_box([350,630], :width => 250, :height => 75) do
      namedinsuredinfo
    end

    move_down(50)
    table policy_table do |tbl|
      tbl.width = 540
      tbl.cells.padding = 2
      tbl.rows(0).style(:borders => [:bottom], :align=>:center)
      tbl.rows(1).style(:borders => [], :align=>:center)
    end
    move_down(12)
    table top_table do |tbl|
      tbl.width = 540
      tbl.cells.padding = 2
      tbl.rows(0).style(:borders => [:bottom, :left, :top, :right], :align=>:center)
      tbl.rows(1).style(:borders => [:bottom, :left, :top, :right], :align=>:center)
    end
    move_down(15)


    table([["Transaction", "Amount"]],:column_widths => [270,270]) do |tbl|
      tbl.width = 540
      tbl.rows(0).style(:borders => [:bottom, :left, :top, :right], :align=>:left, :font_style=>:bold)
      tbl.columns(0).style( :align=>:center, :borders => [:left, :right, :bottom, :top])
      tbl.columns(1).style( :align=>:center,  :borders => [:left, :right, :bottom, :top])
    end

    table(balance_breakdown,:column_widths => [270,270]) do |tbl|
      tbl.width = 540
      tbl.cells.padding = 2
      tbl.row_colors = ["DDDDDD", "FFFFFF"]



      tbl.columns(0).style( :align=>:left, :borders => [:left, :right, :bottom, :top], :size => 10)
      tbl.columns(1).style( :align=>:right,  :borders => [:left, :right, :bottom, :top], :size => 10)

    end
    move_down(5)
    if !payments.nil?


      table(payments,:column_widths => [270,270], :header=>true) do |tbl|
        tbl.width = 540
        tbl.cells.padding = 2
        tbl.row_colors = ["DDDDDD", "FFFFFF"]


        tbl.columns(0).style( :align=>:left, :borders => [:left, :right, :bottom, :top], :size => 10)
        tbl.columns(1).style( :align=>:right,  :borders => [:left, :right, :bottom, :top], :size => 10)
        tbl.rows(0).style(:borders => [:bottom], :align=>:left, :font_style=>:bold, :size=>12)

      end
    end
    move_down(5)
    table(total_due,:column_widths => [270,270]) do |tbl|
      tbl.width = 540

      tbl.rows(0).style(:borders => [:bottom, :left, :top], :align=>:left, :font_style=>:bold,  border_width: 2)
      tbl.columns(1).style( :align=>:right,  :borders => [ :right, :bottom, :top],  border_width: 2)
    end



    move_down(10)

    text "Remit Payment To:", :size => 18, :style => :bold
    agencyinfo

    structure

    if @invoice.outstandingbalance > 0
      if @invoice.policypremiumtransaction.policy.isga  == "GA"
      start_new_page(:template=> "#{Rails.root}/app/pdfs/PDFC-electronicpayment.pdf",top_margin: 25)
      end
    end

  end

  def structure
    line [0,650] , [540,650]
    line [0,10] , [540,10]
    stroke
  end

  def agencyinfo
    if @invoice.policypremiumtransaction.policy.isga == "GA"
      text "#{@invoice.policypremiumtransaction.policy.generalagency.agency_name}"
      text "#{@invoice.policypremiumtransaction.policy.generalagency.address_1}"
      text "#{@invoice.policypremiumtransaction.policy.generalagency.city}, #{@invoice.policypremiumtransaction.policy.generalagency.state} #{@invoice.policypremiumtransaction.policy.generalagency.zip}"
      text "Telephone: #{number_to_phone(@invoice.policypremiumtransaction.policy.generalagency.telephone)}"

    else
      text "#{@invoice.policypremiumtransaction.policy.agency.agency_name}"
      text "#{@invoice.policypremiumtransaction.policy.agency.address_1}"
      text "#{@invoice.policypremiumtransaction.policy.agency.city}, #{@invoice.policypremiumtransaction.policy.agency.state} #{@invoice.policypremiumtransaction.policy.agency.zip}"
      text "Telephone: #{number_to_phone(@invoice.policypremiumtransaction.policy.agency.telephone)}"

    end


  end
  def insuredinfo

    if @invoice.policypremiumtransaction.policy.isga  == "GA"
      text "Producing Agency", :size => 12, :style => :bold
      text "#{@invoice.policypremiumtransaction.policy.producingagency.agency_name} "
      text "#{@invoice.policypremiumtransaction.policy.producingagency.address_1} #{@invoice.policypremiumtransaction.policy.producingagency.address_2}"
      text "#{@invoice.policypremiumtransaction.policy.producingagency.city} ,#{@invoice.policypremiumtransaction.policy.producingagency.state} #{@invoice.policypremiumtransaction.policy.producingagency.zip} "

    else
      text "#{@invoice.policypremiumtransaction.policy.client.fullname} "
      text "#{@invoice.policypremiumtransaction.policy.client.address_1} #{@invoice.policypremiumtransaction.policy.client.address2}"
      text "#{@invoice.policypremiumtransaction.policy.client.city} ,#{@invoice.policypremiumtransaction.policy.client.state} #{@invoice.policypremiumtransaction.policy.client.zip} "
    end



  end

  def namedinsuredinfo
    if @invoice.policypremiumtransaction.policy.isga  == "GA"
      text "Named Insured", :size => 12, :style => :bold
      text "#{@invoice.policypremiumtransaction.policy.namedinsured.named_insured} "
      text "#{@invoice.policypremiumtransaction.policy.namedinsured.address_1} #{@invoice.policypremiumtransaction.policy.namedinsured.address_2}"
      text "#{@invoice.policypremiumtransaction.policy.namedinsured.city} ,#{@invoice.policypremiumtransaction.policy.namedinsured.state} #{@invoice.policypremiumtransaction.policy.namedinsured.zip} "

    else
    end

  end

  def top_table
    [["Policy Number","Policy Effective","Policy Expiration", "Date Created", "Date Due"]] +
        [["#{@invoice.policypremiumtransaction.policy.policy_number}", "#{@invoice.policypremiumtransaction.policy.effective_date.strftime("%m/%d/%Y")}" , "#{@invoice.policypremiumtransaction.policy.expiration_date.strftime("%m/%d/%Y")}" ,"#{@invoice.created_at.strftime("%m/%d/%Y")}", "#{@invoice.due_on.strftime("%m/%d/%Y")}"]]
  end

  def policy_table
    [["Named Insured","Carrier","Coverage", "Transaction Type"]] +
        [[if @invoice.policypremiumtransaction.policy.isga == "GA"
            "#{@invoice.policypremiumtransaction.policy.namedinsured.named_insured}"
          else
            "#{@invoice.policypremiumtransaction.policy.client.fullname}"
          end, "#{@invoice.policypremiumtransaction.policy.carrier.carrier_name}" ,"#{@invoice.policypremiumtransaction.policy.lineofbusiness.line_name}" ,   "#{@invoice.policypremiumtransaction.transaction_type}"]]
  end

  def balance_breakdown

    feearray = []
    feetrans = Feetransaction.select("fee_id, sum(fee_amount) as feesum").where("policypremiumtransaction_id=?",@invoice.policypremiumtransaction.id).group("fee_id")

    feetrans.each do |polfee|
      feearray << ["#{polfee.fee.fee_name}","#{number_to_currency(polfee.feesum,  :negative_format => "(%u%n)")}"]
    end

    if  @invoice.policypremiumtransaction.policy.isga  == "GA"
      [["#{if @invoice.policypremiumtransaction.transaction_type == 'New'
             'New Business'


           elsif @invoice.policypremiumtransaction.transaction_type == 'Endorse'
             'Endorsement: ' + @invoice.policypremiumtransaction.description
           else
             @invoice.policypremiumtransaction.transaction_type.to_s


           end

      }","#{
      if @invoice.policypremiumtransaction.adjusted =='Yes'
        number_to_currency(@invoice.policypremiumtransaction.adjustmentbasep,  :negative_format => "(%u%n)")
      else
        number_to_currency(@invoice.policypremiumtransaction.base_premium,  :negative_format => "(%u%n)")
      end


      }"]]+
          feearray+
          [["Total Premium","#{

          if @invoice.policypremiumtransaction.adjusted =='Yes'
            number_to_currency(@invoice.policypremiumtransaction.adjustmenttotalprem,  :negative_format => "(%u%n)")
          else
            number_to_currency(@invoice.policypremiumtransaction.total_premium,  :negative_format => "(%u%n)")
          end
          }"]]+
          [["Commission #{number_to_percentage((@invoice.policypremiumtransaction.policy.producercommrate)*100,  :negative_format => "(%u%n)")}","#{number_to_currency(@invoice.policypremiumtransaction.pptcommissionproducer,  :negative_format => "(%u%n)")}"]]

    else
      [["#{if (@invoice.policypremiumtransaction.transaction_type == 'New')
             'New Business' else @invoice.policypremiumtransaction.transaction_type end  }","#{number_to_currency(@invoice.policypremiumtransaction.base_premium,  :negative_format => "(%u%n)")}"]]+
          feearray+
          [["Total Premium","#{number_to_currency(@invoice.policypremiumtransaction.total_premium,  :negative_format => "(%u%n)")}"]]

    end

  end

  def payments
    paymentarray = []

    @invoice.cashtransactions.each do |cash|
      paymentarray << ["#{cash.created_at.strftime("%m/%d/%Y")} : #{cash.transaction_type}","#{ number_to_currency(cash.cash_amount * -1,  :negative_format => "(%u%n)")}"]
    end

    if !paymentarray.empty?
      [["Payments/Return Premium Received" ,""]]+

          paymentarray
    end
  end

  def table_header
    [["Transaction", "Amount"]]
  end

  def total_due
    [["Total Due","#{number_to_currency(@invoice.outstandingbalance,  :negative_format => "(%u%n)")}"]]
  end


end
