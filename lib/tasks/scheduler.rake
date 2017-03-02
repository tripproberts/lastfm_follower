desc "Save scrobbles for the previous day"
task save_scrobbles_and_publish_top_songs: :environment do
  from = (Time.now.beginning_of_day - 24.hours).utc
  to = (Time.now.end_of_day - 24.hours).utc
  publisher = SlackPublisher.new
  publisher.publish("*Top Tracks for #{to.strftime("%-m/%-d/%Y")}*\n\n")
  ScrobblerUser.all.each do |user|
    scrobbles = user.fetch_missing_scrobbles(from: from, to: to)
    scrobbles.each { |s| user.association(:scrobbles).add_to_target(s) } unless scrobbles.empty?
    user.save!

    top_tracks = user.get_top_tracks(from: from, to: to)
    #publisher.publish_user_top_tracks(user, top_tracks)
  end
end

desc "Save all missing scrobbles from entire user history"
task save_all_missing_scrobbles: :environment do
  user = ScrobblerUser.first
  from = user.registered_at.beginning_of_day.to_datetime
  to = DateTime.now
  (from..to).each do |d|
    puts "Fetching scrobbles for date: #{d.strftime("%-m/%-d/%Y")}"
    scrobbles = user.fetch_missing_scrobbles(from: d, to: d + 1.day)
    scrobbles.each { |s| user.association(:scrobbles).add_to_target(s) } unless scrobbles.empty?
    user.save!
    puts "Saved #{scrobbles.count} scrobbles"
  end
end

desc "Save scrobbler user info"
task save_scrobbler_user_info: :environment do
  ScrobblerUser.all.each do |u|
    puts "Saving scrobbler user info for user: #{u.username}"
    u.update!(registered_at_int: u.fetch_user_info["registered"]["unixtime"])
  end
end
