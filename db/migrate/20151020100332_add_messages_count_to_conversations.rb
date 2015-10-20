class AddMessagesCountToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :messages_count, :integer, default: 0
  end
end
