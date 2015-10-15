class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :message_type
      t.string :text
      t.references :conversation
      t.references :user
      t.timestamps
    end
  end
end
