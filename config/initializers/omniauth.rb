require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :spotify, ENV['TEN_SPOTIFY_ID'], ENV['TEN_SPOTIFY_SECRET'], scope: 'user-read-email playlist-modify-public'
end
