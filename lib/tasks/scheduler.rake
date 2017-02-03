desc "Sync scrobbles for the previous day"
task sync_scrobbles_and_publish_top_songs: :environment do
  publisher = SlackPublisher.new
  ScrobblerUser.all.each do |user|
    from = (Time.now.beginning_of_day - 24.hours).utc
    to = (Time.now.end_of_day - 24.hours).utc
    scrobbles = user.fetch_missing_scrobbles(from: from, to: to)
    scrobbles.each { |s| user.association(:scrobbles).add_to_target(s) } unless scrobbles.empty?
    user.save!

    top_tracks = user.get_top_tracks(from: from, to: to)
    publisher.publish_top_user_tracks(user, top_tracks, to)
  end
end

