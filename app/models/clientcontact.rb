class Clientcontact < ActiveRecord::Base
  belongs_to :client

  attr_encrypted :ssn, :dlnum, :key => 'ZCNnyYAMs0MrPSdett2LEX1k+rRJFvi4Lw+h7J6CuNb7hcv8YEpxjEbBu7JyFD1HDTJUIipsSBdre8VjwAgxmWfn6Sn9cuQGtZxtdMT8Qx5rYGGFIsUy4ocxms2fh06z'
  attr_accessible :contact_value, :contact_type, :note, :ssn,:dlnum, :dlstate, :dlexp, :birth_date, :sex, :occupation
end
