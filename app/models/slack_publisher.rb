class SlackPublisher

  def initialize
    @client = Slack::Web::Client.new
  end

  def publish_user_top_tracks(user, tracks)
    msg = parse_top_track_text(user, tracks)
    publish(msg)
  end

  def publish(msg)
    if Rails.env.production?
      @client.chat_postMessage(channel: "#now-playing", text: msg, as_user: true)
    else
      puts msg
    end
  end

  private

  def parse_top_track_text(user, tracks)
    msg = "*#{user.username}*\n"
    tracks.each do |track|
      msg << "#{track[1].to_s} plays: #{track[0].artist} - #{track[0].name}\n"
    end
    msg
  end
end
