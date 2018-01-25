class CreateResets < ActiveRecord::Migration[5.1]
  def change
    create_table :resets do |t|
      t.string :email
      t.string :temp_pass
      t.string :person_id_num
      t.string :password_digest
      t.string :reset_type

      t.timestamps
    end
  end
end
