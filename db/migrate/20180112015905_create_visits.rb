class CreateVisits < ActiveRecord::Migration[5.1]
  	def change
    	create_table :visits do |t|
      		t.integer :user_id, null: false
      		t.integer :customer_id, null: false
      		t.integer :chlorine
      		t.integer :ph
      		t.integer :alkalinity
      		t.integer :stabilizer
      		t.integer :salt
      		t.boolean :clean_tile
      		t.boolean :leaf_net
      		t.boolean :vacuum
      		t.boolean :brush
      		t.boolean :skimmer_basket
      		t.boolean :pump_basket
      		t.boolean :clean_filters
      		t.boolean :new_filters
      		t.boolean :add_chlorine
      		t.boolean :add_acid
      		t.boolean :add_bicarb
      		t.boolean :add_stabilizer
      		t.boolean :add_chlorine_tab
      		t.timestamps
   		 end
  	end
end
