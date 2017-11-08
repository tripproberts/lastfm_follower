class ScrobblerUser < ApplicationRecord

  has_many :scrobbles

  def get_top_tracks(limit: 5, from: Time.current.beginning_of_day, to: Time.now.end_of_day)
    scrobbles_in_period = scrobbles.where(uts: from.to_i..to.to_i)
    track_listen_count = Hash.new(0)
    scrobbles_in_period.each { |s| track_listen_count[s.track] += 1 }
    ordered_tracks = track_listen_count.sort_by(&:last).reverse
    ordered_tracks[0,limit]
  end

  def registered_at
    Time.at(registered_at_int)
  end

  def fetch_missing_scrobbles(limit: 200, from:, to: Time.now)
    responses = fetch_scrobbles(limit: limit, from: from, to: to)
    if (responses.empty?)
      []
    else
      response_utss = responses.map { |r| r.uts }
      relevant_scrobble_utss = scrobbles.where(uts: from.to_i..Float::INFINITY).or(scrobbles.where(uts: 0..to.to_i)).map {|s| s.uts}
      utss_to_keep = response_utss - relevant_scrobble_utss
      responses.select { |r| utss_to_keep.include?(r.uts) }
    end
  end

  def fetch_scrobbles(limit: 200, from:, to: Time.now)
    responses = ScrobblerService.new.get_tracks(user: username, limit: limit, from: from.to_i, to: to.to_i)
    responses = [responses] if responses.is_a? Hash
    responses.nil? ? [] : responses.map { |r|
      s = Scrobble.build_from_service(r)
      s.scrobbler_user = self unless s.nil?
      s
    }.compact
  end

  def fetch_user_info
    ScrobblerService.new.get_user_info(username)
  end

end
