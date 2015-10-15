class AddDeviceToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :device, :integer
    add_column :sessions, :device_token, :string
  end
end
