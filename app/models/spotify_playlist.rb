class SpotifyPlaylist < ApplicationRecord

  belongs_to :spotify_user
  belongs_to :scrobbler_user

  def self.needs_updating
    return SpotifyPlaylist.all
  end

  def rspotify_playlist
    @rspotify_playlist ||= spotify_user.get_playlist(spotify_id)
  end

  def update_on_spotify(limit: 10, to: DateTime.now.beginning_of_day.utc, from: DateTime.now.beginning_of_day.utc - 7.days)
    RSpotify::authenticate(ENV['TEN_SPOTIFY_ID'], ENV['TEN_SPOTIFY_SECRET'])
    if spotify_id.nil? or spotify_id.empty?
      id = spotify_user.create_playlist_on_spotify!('10').id
      self.spotify_id = id
    end

    tracks = []
    scrobbler_user.get_top_tracks(limit: limit, from: from, to: to).each do |s|
      track = RSpotify::Track.search(s[0].to_spotify_query).first
      tracks << track unless track == nil
    end
    rspotify_playlist.replace_tracks!(tracks)
    self.last_updated_on_spotify_at = DateTime.now
    save!
  end
end
