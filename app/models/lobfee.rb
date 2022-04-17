class Lobfee < ActiveRecord::Base
  belongs_to :lineofbusiness
  belongs_to :fee

  has_many :feetransactions


  def getfeesforlob(lineofbusiness_id, state)
    @lobfees = Lobfee.find_all_by_lineofbusiness_id(lineofbusiness_id)
    @fees = []
    @lobfees.each do |ld|
      if ld.fee.earn_type == "Pro Rata"

        @fees << Fee.where("id=? AND state =?", ld.fee_id, state)
      end
    end

    @fees
  end

  def getallfeesforlob(lineofbusiness_id, state)
    @lobfees = Lobfee.find_all_by_lineofbusiness_id(lineofbusiness_id)
    @fees = []
    @lobfees.each do |ld|


        @fees << Fee.where("id=? AND state =?", ld.fee_id, state)

    end

    @fees
  end

end
