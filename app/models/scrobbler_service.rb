require 'lastfm'

class ScrobblerService
  API_KEY = ENV['LAST_FM_API_KEY']
  SECRET = ENV['LAST_FM_SECRET']

  def initialize
    @session = get_session
  end

  def get_recent_tracks(user, opts={})
    limit = opts['limit'] || 200
    to = opts['to'] || Time.current.to_i
    from = opts['from'] || (Time.current - 24.hours).to_i
    @session.user.get_recent_tracks(user, limit, nil, to, from)
  end

  private

  def get_session
    Lastfm.new(ScrobblerService::API_KEY, ScrobblerService::SECRET)
  end

end
