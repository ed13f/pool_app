class CreateUsers < ActiveRecord::Migration[5.1]
  	def change
    	create_table :users do |t|
    		t.string :first_name, null: false
      		t.string :last_name, null: false
      		t.string :phone, null: false
      		t.string :email, null: false
      		t.string :password_digest, null: false
      		t.boolean :admin, null: false, default: false
          t.boolean :active_employee, null: false, default: true
      		t.integer :business_id, null: false
      		t.timestamps
    	end
  	end
end
