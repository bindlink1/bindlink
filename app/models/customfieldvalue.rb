class Customfieldvalue < ActiveRecord::Base
  belongs_to :customfield
  belongs_to :policy
  belongs_to :client
  belongs_to :producingagency

  attr_encrypted :evalue, :key => 'ZCNnyYAMs0MrPSdett2LEX1k+rRJFvi4Lw+h7J6CuNb7hcv8YEpxjEbBu7JyFD1HDTJUIipsSBdre8VjwAgxmWfn6Sn9cuQGtZxtdMT8Qx5rYGGFIsUy4ocxms2fh06z'
  attr_accessible :evalue, :value, :value_date, :customfield_id


end
