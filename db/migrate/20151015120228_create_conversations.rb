class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.references :initiator
      t.references :opponent
      t.boolean :in_radius

      t.timestamps
    end
  end
end
