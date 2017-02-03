class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
      t.string :artist
      t.string :artist_mbid
      t.string :name
      t.string :mbid
      t.string :album
      t.string :album_mbid

      t.timestamps
    end
  end
end
