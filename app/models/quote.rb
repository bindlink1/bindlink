class Quote < ActiveRecord::Base
  belongs_to :submission
  belongs_to :client
  belongs_to :carrier
  belongs_to :lineofbusiness
  belongs_to :agency
  belongs_to :generalagency
  belongs_to :namedinsured
  has_one :policy
  has_many :notes, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :tasks, :dependent => :destroy

  attr_accessible :carrier_id, :lobcommission_id, :lineofbusiness_id ,:base_premium, :total_fees, :total_premium, :quotedescription

  def bindquote

    if self.status != "bound"

      self.status = "bound"
      self.save

    end


  end


end
