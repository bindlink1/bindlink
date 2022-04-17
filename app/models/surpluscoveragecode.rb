class Surpluscoveragecode < ActiveRecord::Base
	def coverage_readable
    	self.coverage_description + ' | ' + self.coverage_code.to_s
  end
end
