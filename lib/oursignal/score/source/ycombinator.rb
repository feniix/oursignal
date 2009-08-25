require 'oursignal/score/source'
require 'nokogiri'

module Oursignal
  module Score
    class Source
      class Ycombinator < Source
        def http_uri
          @http_uri ||= uri('http://news.ycombinator.com/').freeze
        end

        def work(data = '')
          Nokogiri::HTML.parse(data).css('td.title a').each do |entry|
            points = entry.xpath('../../following-sibling::tr[1]/td/span').text.to_i
            url    = entry.attribute('href').text
            url    = 'http://news.ycombinator.com/' + url unless url =~ %r{://}
            score(url, points) if points > 0
          end
        end
      end # Ycombinator
    end # Source
  end # Score
end # Oursignal
