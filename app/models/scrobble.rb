class Scrobble < ApplicationRecord

  belongs_to :track
  belongs_to :scrobbler_user

  def self.build_from_service(response)
    nowplaying = response.fetch("nowplaying", false)
    unless (nowplaying)
      track = Track.find_or_create_by(
        album: response.fetch("album", {}).fetch("content", ""),
        album_mbid: response.fetch("album", {}).fetch("mbid", ""),
        artist: response.fetch("artist", {}).fetch("content", ""),
        artist_mbid: response.fetch("artist", {}).fetch("mbid", ""),
        mbid: response["mbid"] == {} ? "" : response["mbid"],
        name: response.fetch("name", "")
      )
      Scrobble.new(
        track: track,
        uts: response.fetch("date", {}).fetch("uts")
      )
    end
  end

end
