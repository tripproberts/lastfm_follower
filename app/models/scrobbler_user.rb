class ScrobblerUser

  attr_accessor :name

  def self.all
    [ScrobblerUser.new("tripproberts")]
  end

  def initialize(name)
    @name = name
  end

  def get_top_tracks(limit=5)
    recent_songs = ScrobblerService.new.get_recent_tracks(name)
    song_listen_count = Hash.new(0)
    recent_songs.each { |song| song_listen_count[song.except("nowplaying", "date")] += 1 }
    ordered_songs = song_listen_count.sort_by(&:last).reverse
    ordered_songs[0,limit]
  end
end
