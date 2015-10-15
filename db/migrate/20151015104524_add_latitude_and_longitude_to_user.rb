class AddLatitudeAndLongitudeToUser < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :location_updated_at, :datetime
  end
end
