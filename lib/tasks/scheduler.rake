desc "Download new scrobbles and update playlists"
task download_scrobbles_and_update_playlists: :environment do
  DownloadNewScrobblesJob.new({
    from: Time.now.beginning_of_day.utc - 1.day,
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
