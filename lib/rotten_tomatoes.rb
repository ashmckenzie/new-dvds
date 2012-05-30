module RottenTomatoes

  def self.api_key
    $CONFIG.rotten_tomatoes.api_key
  end    

  def self.new_dvd_releases
    url = Url.new('/lists/dvds/new_releases.json')

    Request.new(url).collect do |page|
      page['movies'].collect { |m| NewDvds::Movie.new(m) }
    end.flatten
  end
end