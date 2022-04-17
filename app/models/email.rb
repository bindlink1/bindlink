class Email < ActiveRecord::Base
  attr_accessible :from, :to, :subject, :body, :document_id
end
