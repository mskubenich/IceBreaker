class AddShowEmailToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :show_email, :boolean
  end
end
