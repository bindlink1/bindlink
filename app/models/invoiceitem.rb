class Invoiceitem < ActiveRecord::Base
  belongs_to :invoice
  has_many :accountingtransactions

end
