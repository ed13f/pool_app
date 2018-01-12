class CreateNotes < ActiveRecord::Migration[5.1]
  	def change
    	create_table :notes do |t|
    		t.integer :customer_id, null: false
      		t.string :description, null: false
      		t.timestamps
    	end
  	end
end
