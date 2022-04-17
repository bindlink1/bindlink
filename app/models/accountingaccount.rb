class Accountingaccount < ActiveRecord::Base
  has_one :contra_account, :class_name =>"Accountingaccount", :foreign_key => "contra_account_ref_id"

end
