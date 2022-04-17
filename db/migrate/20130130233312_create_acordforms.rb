class CreateAcordforms < ActiveRecord::Migration
  
	def change
    
		create_table :acordforms do |t|

      
			t.string :form_name
			t.timestamps
    
		
		end
  

	end

end
