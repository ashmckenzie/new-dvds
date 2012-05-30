module NewDvds
  def self.notify

    unless $DRY_ON
      Mongoid.configure do |config|
        name = "new_dvds"
        host = "127.0.0.1"
        config.master = Mongo::Connection.new.db(name)
        config.persist_in_safe_mode = false
      end
    end

    movies = RottenTomatoes.new_dvd_releases

    unless movies.empty? 
      Emailer.transmit(movies)
    else
      $logger.info "There are no new DVD's"
    end
  end
end