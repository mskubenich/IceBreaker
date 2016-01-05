class ResetLocationsWorker
  include Sidekiq::Worker
  sidekiq_options queue: "reset_locations_worker"
  sidekiq_options retry: false

  def perform
    User.find_each do |user|
      if user.location_updated_at && user.location_updated_at.utc < (Time.now - 75.seconds).utc
        user.reset_location
      end
    end
  end
end
