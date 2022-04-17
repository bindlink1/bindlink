class Al3file < ActiveRecord::Base
  belongs_to :agency
  has_many :al3h2trgs
end
