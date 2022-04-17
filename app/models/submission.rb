class Submission < ActiveRecord::Base
  belongs_to :agency
  belongs_to :generalagency
  belongs_to :client
  belongs_to :producingagency
  belongs_to :namedinsured
  has_many :conversations
  has_many :quotes
  has_many :notes
  has_many :documents
  accepts_nested_attributes_for :client
  accepts_nested_attributes_for :quotes
  accepts_nested_attributes_for :namedinsured

  attr_accessible :agent_id, :producingagency_id, :namedinsured_attributes, :short_note, :named_insured

  def totalquotecount
    quotecount = Quote.find_all_by_submission_id(self.id).count

  end



end
