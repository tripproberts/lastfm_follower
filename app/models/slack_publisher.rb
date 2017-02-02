class SlackPublisher

  def initialize
    @client = Slack::Web::Client.new
  end

  def publish_top_songs_of_the_day
    msg = ""
    ScrobblerUser.all.each do |user|
      msg << parse_top_track_text(user, user.get_top_tracks)
    end
    @client.chat_postMessage(channel: "#now-playing", text: msg, as_user: true)
  end

  private

  def parse_top_track_text(user, tracks)
    msg = "User: #{user.name}\n" +
          "Date: #{(Time.current.to_date - 1.days).strftime("%-m/%-d/%Y")}\n" +
          "\n" +
          "Top tracks:\n"
    tracks.each do |track|
      msg << "#{track[1].to_s} plays: #{track[0]["artist"]["content"]} - #{track[0]["name"]}\n"
    end
    msg
  end
end
