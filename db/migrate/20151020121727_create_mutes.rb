class CreateMutes < ActiveRecord::Migration
  def change
    create_table :mutes do |t|
      t.references :initiator
      t.references :opponent
      t.timestamps
    end
  end
end
