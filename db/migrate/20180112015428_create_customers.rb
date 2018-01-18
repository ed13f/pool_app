class CreateCustomers < ActiveRecord::Migration[5.1]
  	def change
    	create_table :customers do |t|
    		t.string :first_name, null: false
      		t.string :last_name, null: false
      		t.string :phone, null: false
      		t.string :email, null: false
      		t.string :street_address, null: false
      		t.string :city, null: false
      		t.string :state, null: false
      		t.string :zip_code, null: false
      		t.string :gate_code
      		t.string :service_day
      		t.string :filter_type
      		t.string :pump_type
      		t.float :latitude
      		t.float :longitude
      		t.integer :user_id, null: false
      		t.boolean :weekly_complete, :default => false
      		t.string :weekly_visit_str, :default => ""
      		t.boolean :monday
          t.boolean :tuesday
          t.boolean :wednesday
          t.boolean :thursday
          t.boolean :friday
          t.boolean :spa
      		t.timestamps
      		t.timestamps
    	end
  	end
end
