class CreateBusinesses < ActiveRecord::Migration[5.1]
  	def change
    	create_table :businesses do |t|
    		t.string :owners_first_name
      		t.string :owners_last_name
      		t.string :business_name
      		t.string :phone, null: false
      		t.string :email, null: false
          t.string :password
      		t.timestamps
    	end
  	end
end
