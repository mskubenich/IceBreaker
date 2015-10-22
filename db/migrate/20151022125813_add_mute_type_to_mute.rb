class AddMuteTypeToMute < ActiveRecord::Migration
  def change
    add_column :mutes, :mute_type, :integer, default: 0
  end
end
