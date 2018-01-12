class CreateImages < ActiveRecord::Migration[5.1]
  	def change
    	create_table :images do |t|
    		t.integer :repair_id, null: false
      		t.timestamps
    	end
  	end
end
