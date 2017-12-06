class UsersController < ApplicationController
  def spotify
    rspotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    scrobbler_user = ScrobblerUser.find_or_create_by(username: 'tripproberts')
    spotify_user = SpotifyUser.find_or_create_by(spotify_id: rspotify_user.id)
    spotify_user.update!(rspotify_hash: rspotify_user.to_hash)
    playlist = spotify_user.spotify_playlists.find_or_create_by(scrobbler_user: scrobbler_user, spotify_user: spotify_user)
    playlist.update_on_spotify
  end
end
