module NewDvds

  VERY_LOW = -2
  MODERATE = -1
  NORMAL = 0
  HIGH = 1
  EMERGENCY = 2

  def self.notify
    jobs = []

    unless $DRY_ON
      Mongoid.configure do |config|
        name = "vline_updates"
        host = "127.0.0.1"
        config.master = Mongo::Connection.new.db(name)
        config.persist_in_safe_mode = false
      end
    end

    Updates.obtain.collect do |detail|
      payload = {
        detail: detail,
        apikey: $CONFIG.nma.api_key,
        application: $CONFIG.name,
        event: detail.event,
        description: detail.description,
        priority: detail.priority
      }

      $logger.info payload[:detail]
      payload.delete(:detail)

      jobs << Thread.new { Request.new.send(payload) unless $DRY_ON }
    end

    jobs.collect { |job| job.join }
  end
end