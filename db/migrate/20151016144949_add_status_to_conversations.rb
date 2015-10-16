class AddStatusToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :status, :integer, default: 0
    add_column :conversations, :removed_by, :integer
  end
end
