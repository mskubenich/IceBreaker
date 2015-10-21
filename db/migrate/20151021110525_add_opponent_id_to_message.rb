class AddOpponentIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :opponent_id, :integer
  end
end
