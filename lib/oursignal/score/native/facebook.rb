require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      #--
      # TODO: Facebook actually accepts a comma separated list of URLs without an API key.
      # Make less requests by chunking URLs if we can find an upper limit.
      class Facebook < Native
        def url
          "http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&urls=#{URI.escape(link.url)}&format=json&callback=fb_sharepro_render"
        end

        def parse source
          json  = source.gsub(/^(.*);+\n*$/, "\\1").gsub(/^fb_sharepro_render\((.*)\)$/, "\\1")
          data  = Yajl::Parser.new(symbolize_keys: true).parse(json)
          score = data.first[:share_count] || return # Also like_count, comment_count, click_count and total_count if we need it.
          puts "facebook:link(#{link.id}, #{link.url}):#{score}"
          Link.execute("update links set score_facebook = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Facebook
    end # Native
  end # Score
end # Oursignal

__END__
fb_sharepro_render(
  [
    {
      "url": "http:\/\/google.com"
      "normalized_url": "http:\/\/www.google.com\/",
      "share_count": 763250,
      "like_count": 275286,
      "comment_count": 294467,
      "total_count": 1333003,
      "click_count": 265614,
      "comments_fbid": 383926826594
      "commentsbox_count": 0
    },
    {
      "url": "http:\/\/digg.com",
      "normalized_url": "http:\/\/www.digg.com\/",
      "share_count": 3486,
      "like_count": 399,
      "comment_count": 441,
      "total_count": 4326,
      "click_count": 1649,
      "comments_fbid": 387096841422,
      "commentsbox_count": 0
    }
  ]
);
