class Statementitem < ActiveRecord::Base
  belongs_to :statement
  belongs_to :policypremiumtransaction


  def addppt(ppt_ids, statement_id)

    ppt_ids.each do |p|
      item = Statementitem.new
      item.policypremiumtransaction_id =  p[:ppt_id]
      item.statement_id = statement_id
      item.save
    end


  end


end
