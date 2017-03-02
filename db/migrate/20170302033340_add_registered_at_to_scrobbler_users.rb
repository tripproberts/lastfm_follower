class AddRegisteredAtToScrobblerUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :scrobbler_users, :registered_at_int, :integer
  end
end
