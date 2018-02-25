class CreateBusinesses < ActiveRecord::Migration[5.1]
  	def change
    	create_table :businesses do |t|
    		t.string :owners_first_name, null: false
    		t.string :owners_last_name, null: false
    		t.string :business_name, null: false
    		t.string :phone, null: false
    		t.string :email, null: false
        t.string :password_digest, null: false
    		t.timestamps
    	end
  	end
end
