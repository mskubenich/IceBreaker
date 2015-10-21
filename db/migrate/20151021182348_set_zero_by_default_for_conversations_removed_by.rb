class SetZeroByDefaultForConversationsRemovedBy < ActiveRecord::Migration
  def change
    remove_column :conversations, :removed_by
    add_column :conversations, :removed_by, :integer, default: 0
  end
end
