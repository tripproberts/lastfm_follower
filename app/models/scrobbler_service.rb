require 'lastfm'

class ScrobblerService
  API_KEY = ENV['LAST_FM_API_KEY']
  SECRET = ENV['LAST_FM_SECRET']

  def initialize
    @session = get_session
  end

  def get_user_info(user)
    @session.user.get_info(user)
  end

  def get_tracks(user:, limit:, from:, to:)
    @session.user.get_recent_tracks(user, limit, nil, to, from)
  end

  private

  def get_session
    Lastfm.new(ScrobblerService::API_KEY, ScrobblerService::SECRET)
  end

end
