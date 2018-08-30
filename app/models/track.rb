class Track < ApplicationRecord
  has_many :scrobbles

  def to_spotify_query
    album.nil? || album.empty? ? "artist:#{artist} track:#{name}"
                               : "artist:#{artist} track:#{name} album:#{album}"
  end
end
