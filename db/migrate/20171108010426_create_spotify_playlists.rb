class CreateSpotifyPlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :spotify_playlists do |t|
      t.string :spotify_id
      t.integer :spotify_user_id
      t.integer :scrobbler_user_id
      t.datetime :last_updated_on_spotify_at

      t.timestamps
    end
  end
end
