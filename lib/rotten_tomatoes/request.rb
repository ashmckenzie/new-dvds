module RottenTomatoes
  class Request

    include Enumerable

    def initialize url
      @responses = []

      begin
        @responses << JSON.parse(get(url))
        url.page_number = url.page_number += 1
      end while more_pages?(url)
    end

    def each &block
      @responses.each(&block)
    end

    private

    def more_pages? url
      ((@responses.first['total'].to_f / url.page_limit.to_f).to_f.ceil) >= url.page_number
    end

    def get url
      RestClient.get(url.to_s)
    end
  end
end