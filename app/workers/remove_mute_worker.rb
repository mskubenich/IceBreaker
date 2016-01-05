class RemoveMuteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "remove_mute_worker"
  sidekiq_options retry: false

  def perform
    Mute.find_each do |mute|
      if mute.updated_at < (Time.now.utc - 5.minutes)
        mute.destroy
      end
    end
  end
end
