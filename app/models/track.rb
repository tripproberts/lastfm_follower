class Track < ApplicationRecord
  has_many :scrobbles

  def to_spotify_query
    "artist:#{artist} track:#{name}".gsub("'","")
  end
end
