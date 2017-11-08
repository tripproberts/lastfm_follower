class DownloadNewScrobblesJob
  attr_accessor :users, :from, :to

  def initialize(params={})
    @users = params.fetch(:users, ScrobblerUser.none) # Default is empty active record relation
    @from = params.fetch(:from, (Time.now.beginning_of_day - 1.days).utc)
    @to = params.fetch(:to, Time.now.beginning_of_day.utc)
  end

  def doJob()
    @users.each do |user|
      scrobbles = user.fetch_missing_scrobbles(from: @from, to: @to)
      scrobbles.each { |s| user.association(:scrobbles).add_to_target(s) } unless scrobbles.empty?
      user.save!
      puts "Saved #{scrobbles.count} scrobbles for user #{user.username}"
    end
  end

end
