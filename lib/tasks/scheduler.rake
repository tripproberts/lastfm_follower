desc "Download new scrobbles and update playlists"
task download_scrobbles_and_update_playlists: :environment do
  DownloadNewScrobblesJob.new({
    from: Time.now.beginning_of_day.utc - 3.day,
    to: Time.now.end_of_day.utc - 1.day,
    users: ScrobblerUser.all
  }).doJob
  SpotifyPlaylist.needs_updating.each do |p| p.update_on_spotify end
end

desc "Save scrobbler user info"
task save_scrobbler_user_info: :environment do
  ScrobblerUser.all.each do |u|
    puts "Saving scrobbler user info for user: #{u.username}"
    u.update!(registered_at_int: u.fetch_user_info["registered"]["unixtime"])
  end
end

desc "Save all missing scrobbles from entire user history"
task :save_all_missing_scrobbles, [:username, :from, :to] => :environment do |t, args|
  user = ScrobblerUser.find_by_username(args.username)
  from = Date.strptime(args.from, "%Y-%m-%d").beginning_of_day.to_datetime
  to = Date.strptime(args.to, "%Y-%m-%d").beginning_of_day.to_datetime
  (from..to).each do |d|
    puts "Fetching scrobbles for date: #{d.strftime("%-m/%-d/%Y")}"
    scrobbles = user.fetch_missing_scrobbles(from: d, to: d + 1.day)
    scrobbles.each { |s| user.association(:scrobbles).add_to_target(s) } unless scrobbles.empty?
    user.save!
    puts "Saved #{scrobbles.count} scrobbles"
  end
end

desc "Merge tracks with same artist and song"
task merge_tracks: :environment do
  Track.all.order(:created_at).each do |t|
    other_tracks = Track.where(name: t.name, artist: t.artist)
    other_tracks.each do |other_track|
      if other_track.id != t.id
        other_scrobbles = other_track.scrobbles
        # scrobbles.update_all(track_id: t.id)
        puts "Moving " + other_scrobbles.size.to_s + " scrobbles from " + other_track.artist + " - " + other_track.name + " to " + t.artist + " - " + t.name
      end
    end
  end
end
