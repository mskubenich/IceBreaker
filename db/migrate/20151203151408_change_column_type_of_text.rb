class ChangeColumnTypeOfText < ActiveRecord::Migration
  def change
    change_column :messages, :text, :text
  end
end
