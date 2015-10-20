class ResetLocationsWorker
  include Sidekiq::Worker
  sidekiq_options queue: "reset_locations_worker"
  sidekiq_options retry: false

  def perform
    User.find_each do |user|
      if user.location_updated_at && user.location_updated_at > (Time.now - 5.minutes)
        user.update_attributes longitude: nil, latitude: nil, location_updated_at: nil
      end
    end
  end
end