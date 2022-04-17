class Statement < ActiveRecord::Base
  before_save :agencyrecord
  has_many :statementitems, :dependent => :destroy
  belongs_to :agency
  belongs_to :generalagency
  belongs_to :carrier
  belongs_to :agent


  attr_accessible :carrier_id, :start_date, :end_date, :agent_id

  def agencyrecord

    if self.agent.isgeneralagent == "Retail"
      self.agency_id = self.agent.agency_id
    else
      self.generalagency_id = self.agent.generalagency_id
    end
  end


  def self.open_spreadsheet(file)
    require 'roo-xls'

    case File.extname(file.original_filename)
      when '.csv' then Roo::Csv.new(file.path, file_warning: :ignore)
      when '.xls' then Roo::Excel.new(file.path, file_warning: :ignore)
      when '.xlsx' then Roo::Excelx.new(file.path, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def statementppts

    #statement needs ppts
    # if the statement has directbill installments then we dont need the ppts
    #if !self.carrier.hasdirectbillinstallments
=begin
      if  params[:allunrec] == 'All'
        if self.agent.isgeneralagent == "Retail"
          @ppts = Policypremiumtransaction.new.unreconciliedtransactions(self.agent.agency_id,"Retail", self.carrier_id)
        else
          @ppts = Policypremiumtransaction.new.unreconciliedtransactions(self.agent.generalagency_id,"GA",  self.carrier_id )
        end

      else
=end
      if self.agent.isgeneralagent == "Retail"
        @ppts = Policypremiumtransaction.new.reconciliationtransactions(self.agent.agency_id,"Retail", self.start_date, self.end_date,  self.carrier_id)
      else
        @ppts = Policypremiumtransaction.new.reconciliationtransactions(self.agent.generalagency_id,"GA", self.start_date, self.end_date, self.carrier_id )

      end
      # end
    #end

    @ppts
  end

end
