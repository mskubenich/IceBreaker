class CreateUsers < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string :encrypted_password
        t.string :salt
        t.string :email
      end
  end
end