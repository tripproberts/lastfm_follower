class DropAlbumFromTracks < ActiveRecord::Migration[5.0]
  def change
    remove_column :tracks, :album
    remove_column :tracks, :album_mbid
  end
end
