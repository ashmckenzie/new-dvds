module RottenTomatoes
  class Url

    PAGE_LIMIT = 16
    BASE_URL = 'http://api.rottentomatoes.com/api/public/v1.0'

    attr_reader :path, :page_limit
    attr_accessor :page_number

    def initialize path, page_number=1, page_limit=PAGE_LIMIT
      @path = path
      @page_number = page_number
      @page_limit = page_limit
    end

    def to_s
      "#{BASE_URL}#{path}?page=#{page_number}&page_limit=#{page_limit}&apikey=#{RottenTomatoes::api_key}"
    end
  end
end