class CreateDays < ActiveRecord::Migration[5.1]
  	def change
    	create_table :days do |t|
    		t.string :monday
    		t.string :tuesday
    		t.string :wednesday
    		t.string :thursday
    		t.string :friday
    		t.integer :customer_id
    		t.timestamps
    	end
  	end
end
