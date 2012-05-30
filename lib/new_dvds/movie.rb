module NewDvds
  class Movie

    attr_reader :detail

    def initialize hash
      @detail = RecursiveOpenStruct.new hash
    end

    def id
      detail.id
    end

    def link
      detail.links.alternate
    end

    def title
      detail.title
    end

    def synopsis
      detail.synopsis
    end

    def year
      detail.year
    end

    def critics_score
      detail.ratings.critics_score
    end

    def audience_score
      detail.ratings.audience_score
    end

    def cast
      detail.abridged_cast.collect { |x| x['name'] }
    end

    def image
      detail.posters.detailed
    end

    def dvd_release_date
      Time.zone.parse detail.release_dates.dvd
    end
  end
end