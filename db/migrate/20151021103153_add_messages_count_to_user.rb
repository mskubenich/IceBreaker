class AddMessagesCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :sended_messages_count, :integer, default: 0
    add_column :users, :received_messages_count, :integer, default: 0
  end
end
