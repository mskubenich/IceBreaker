class AddLocationUpdatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location_updated__at, :datetime
  end
end
