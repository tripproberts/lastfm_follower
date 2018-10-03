class Track < ApplicationRecord
  has_many :scrobbles

  def to_spotify_query
    base = album.nil? || album.empty? ? "artist:#{artist} track:#{name}"
                                      : "artist:#{artist} track:#{name} album:#{album}"
    base.gsub("'","")
  end
end
