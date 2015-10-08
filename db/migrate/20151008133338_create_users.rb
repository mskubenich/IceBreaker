class CreateUsers < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string :user_name
        t.string :first_name
        t.string :last_name
        t.integer :gender
        t.date :date_of_birth
        t.string :encrypted_password
        t.string :salt
        t.string :email
      end
  end
end