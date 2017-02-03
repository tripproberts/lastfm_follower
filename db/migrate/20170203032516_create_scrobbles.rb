class CreateScrobbles < ActiveRecord::Migration[5.0]
  def change
    create_table :scrobbles do |t|
      t.integer :track_id
      t.integer :uts
      t.integer :scrobbler_user_id

      t.timestamps
    end
  end
end
