class SlackPublisher

  def initialize
    @client = Slack::Web::Client.new
  end

  def publish_top_user_tracks(user, tracks, date)
    msg = parse_top_track_text(user, tracks, date)
    @client.chat_postMessage(channel: "#now-playing", text: msg, as_user: true)
  end

  private

  def parse_top_track_text(user, tracks, date)
    msg = "User: #{user.username}\n" +
          "Date: #{date.strftime("%-m/%-d/%Y")}\n" +
          "\n" +
          "Top tracks:\n"
    tracks.each do |track|
      msg << "#{track[1].to_s} plays: #{track[0].artist} - #{track[0].name}\n"
    end
    msg
  end
end
