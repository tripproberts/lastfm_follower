class CreateSpotifyUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :spotify_users do |t|
      t.string :spotify_id, unique: true
      t.text :rspotify_hash

      t.timestamps
    end
  end
end
