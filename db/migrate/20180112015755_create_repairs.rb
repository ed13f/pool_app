class CreateRepairs < ActiveRecord::Migration[5.1]
  	def change
    	create_table :repairs do |t|
			t.integer :customer_id, null: false
      		t.string :title, null: false
      		t.string :description, null: false
      		t.boolean :complete, :default => false
      		t.integer :user_id
      		t.timestamps
    	end
  	end
end
