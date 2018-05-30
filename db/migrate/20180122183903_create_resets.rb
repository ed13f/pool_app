class CreateResets < ActiveRecord::Migration[5.1]
  def change
    create_table :resets do |t|
      t.string :email, null: false
      t.string :temp_pass, null: false
      t.string :person_id_num, null: false
      t.string :password_digest
      t.string :reset_type, null: false

      t.timestamps
    end
  end
end
