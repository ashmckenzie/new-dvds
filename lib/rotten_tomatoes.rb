module RottenTomatoes

  def self.api_key
    $CONFIG.rotten_tomatoes.api_key
  end    

  def self.new_dvd_releases
    releases = []
    url = Url.new('/lists/dvds/new_releases.json')

    Request.new(url).each do |page|
      page['movies'].each do |m|
        movie = NewDvds::Movie.new(m)
        unless $DRY_ON
          $logger.debug "Checking #{movie}"
          unless NewDvds::Movie.exists?(conditions: { movie_id: movie.id })
            movie.save
            releases << movie
            $logger.info "Added to releases - #{movie}"
          else
            $logger.debug "Movie already exists - #{movie}"
          end
        else
          releases << movie
        end
      end
    end

    releases.flatten
  end
end