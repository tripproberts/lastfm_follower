desc "Sync scrobbles for the previous day"
task sync_scrobbles_and_publish_top_songs: :environment do
  from = (Time.now.beginning_of_day - 24.hours).utc
  to = (Time.now.end_of_day - 24.hours).utc
  publisher = SlackPublisher.new
  publisher.publish("*Top Tracks for #{to.strftime("%-m/%-d/%Y")}*\n\n")
  ScrobblerUser.all.each do |user|
    scrobbles = user.fetch_missing_scrobbles(from: from, to: to)
    scrobbles.each { |s| user.association(:scrobbles).add_to_target(s) } unless scrobbles.empty?
    user.save!

    top_tracks = user.get_top_tracks(from: from, to: to)
    publisher.publish_user_top_tracks(user, top_tracks)
  end
end

