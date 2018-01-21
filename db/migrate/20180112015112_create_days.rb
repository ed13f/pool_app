class CreateDays < ActiveRecord::Migration[5.1]
  	def change
    	create_table :days do |t|
    		t.boolean :monday
    		t.boolean :tuesday
    		t.boolean :wednesday
    		t.boolean :thursday
    		t.boolean :friday
    		t.integer :customer_id
    		t.timestamps
    	end
  	end
end
