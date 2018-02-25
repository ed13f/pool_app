class CreateVisits < ActiveRecord::Migration[5.1]
  	def change
    	create_table :visits do |t|
      		t.integer :user_id, null: false
      		t.integer :customer_id, null: false
      		t.integer :chlorine
      		t.integer :ph, null: false
      		t.integer :alkalinity, null: false
      		t.integer :stabilizer
      		t.integer :salt
      		t.boolean :clean_tile, :default => false
      		t.boolean :leaf_net, :default => false
      		t.boolean :vacuum, :default => false
      		t.boolean :brush, :default => false
      		t.boolean :skimmer_basket, :default => false
      		t.boolean :pump_basket, :default => false
      		t.boolean :clean_filters, :default => false
      		t.boolean :new_filters, :default => false
      		t.boolean :add_chlorine, :default => false
      		t.boolean :add_acid, :default => false
      		t.boolean :add_bicarb, :default => false
      		t.boolean :add_stabilizer, :default => false
      		t.boolean :add_chlorine_tab, :default => false
      		t.timestamps
   		 end
  	end
end
