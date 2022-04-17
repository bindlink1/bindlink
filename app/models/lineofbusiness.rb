class Lineofbusiness < ActiveRecord::Base
  belongs_to :agency
  belongs_to :generalagency
  has_many :carriers, :through => :carrierlobs
  has_many :fees, :through => :lobfees
  has_many :policies
  belongs_to :lobbroadcategory

  attr_accessible :line_name, :coverage_code, :lobbroadcategory_id

  def associatedfees
    @associatedfees= Lobfee.find_all_by_lineofbusiness_id(self.id)
  end

  def nonassociatedfees(associatedfees, agentid)
    associated = []

    associatedfees.each do |afee|
      associated << afee.fee_id
    end

    if associated.empty?
      associated << 0
    end

    @agent = Agent.find(agentid)

    if @agent.isgeneralagent == "Retail"
      @allfees = Fee.where('id not in (?)',associated).find_all_by_agency_id(@agent.agency_id)

    else
      @allfees = Fee.where('id not in (?)',associated).find_all_by_generalagency_id(@agent.generalagency_id)
    end

    @allfees

  end

end
