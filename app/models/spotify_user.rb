class SpotifyUser < ApplicationRecord

  serialize :rspotify_hash

  has_many :spotify_playlists

  def create_playlist_on_spotify!(name)
    RSpotify::authenticate(ENV['TEN_SPOTIFY_ID'], ENV['TEN_SPOTIFY_SECRET'])
    rspotify_user = RSpotify::User.new(rspotify_hash)
    return rspotify_user.create_playlist!(name)
  end

  def get_playlist(playlist_spotify_id)
    RSpotify::authenticate(ENV['TEN_SPOTIFY_ID'], ENV['TEN_SPOTIFY_SECRET'])
    return RSpotify::User.new(rspotify_hash).playlists().select { |p| p.id == playlist_spotify_id }.first
  end
end
