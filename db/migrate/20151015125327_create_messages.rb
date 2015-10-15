class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.references :conversation
      t.references :author
      t.boolean :viewed, default: false
      t.timestamps
    end
  end
end
