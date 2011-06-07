require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      #--
      # Note: The 'API' below has no rate limiting or it'd have headers for it ;)
      # Dunno how long till twitter realize or if it's just not sending the X-FeatureRateLimit-* headers the docs
      # say should be sent. Probably no limit since it's really designed for client side JS and people may visit
      # enough sites to see more than 150 twitter buttons (their non auth limit) in an hour easy.
      class Twitter < Native
        def url
          "http://urls.api.twitter.com/1/urls/count.json?url=#{URI.escape(link.url)}"
        end

        def parse source
          data  = Yajl::Parser.new(symbolize_keys: true).parse(source)
          score = data[:count] || return
          puts "twitter:link(#{link.id}, #{link.url}):#{score}"
          Link.execute("update links set score_twitter = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Twitter
    end # Native
  end # Score
end # Oursignal

__END__

{
  "count": 8,
  "url": "http://www.teamliquid.net/sc2/"
}
