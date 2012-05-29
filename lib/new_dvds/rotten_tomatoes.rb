module NewDvds
  class RottenTomatoes

    PER_PAGE = 16

    def self.url
      $CONFIG.rotten_tomatoes.url
    end

    def self.api_key
      $CONFIG.rotten_tomatoes.api_key
    end    

    def self.new_dvd_releases_url page=1, page_limit=PER_PAGE
       "#{url}/lists/dvds/new_releases.json?page_limit=#{page_limit}&page=#{page}&apikey=#{api_key}"
    end

    def self.new_dvd_releases
      new.retrieve_new_dvd_releases.collect { |m| Movie.new m }
    end

    def retrieve_new_dvd_releases
      # JSON.parse(File.read('./tmp/new_releases.json'))['movies'].flatten

      pages = []
      pages << get

      (2...(pages.first['total'].to_i / PER_PAGE) + 1).each do |page|
        pages << get(page)
      end

      pages.collect { |page| page['movies'] }.flatten
    end

    private

    def get page=1
      JSON.parse(RestClient.get(RottenTomatoes.new_dvd_releases_url(page)))
    end
  end
end