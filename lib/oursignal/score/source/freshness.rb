require 'oursignal/score/source'

module Oursignal
  module Score
    class Source
      class Freshness < Source
        ABOVE_GLOBAL_AVERAGE_DAILY_LINKS = 1.5
        DECAY_IN_HOURS                   = 24.0
        TODO_RESULT_WEIGHT               = 0.5

        def call
          # TODO: This is going to be expensive later.
          global_average_daily_links = Feed.avg(:daily_links).to_f

          Link.all.each do |link|
            # Age in minutes.
            age = ((Time.now - link.referred_at.to_time).to_f / 1.hour)

            # Average daily links across all feeds that have this link.
            feeds               = Feed.all('feed_links.link_id' => link.id) # TODO: Why is link.feeds doing the wrong query?
            average_daily_links = feeds.empty? ? 0 : (feeds.inject(0.0){|ac, feed| ac += feed.daily_links; ac} / feeds.size)

            # Decay the link from 1 to 0 over time.
            result = age < DECAY_IN_HOURS ? ((DECAY_IN_HOURS.to_f - age) / DECAY_IN_HOURS) : 0

            # Adjust this score by the spammyness of the feeds it appears in.
            if average_daily_links > (global_average_daily_links * ABOVE_GLOBAL_AVERAGE_DAILY_LINKS)
              result *= (global_average_daily_links * ABOVE_GLOBAL_AVERAGE_DAILY_LINKS) / average_daily_links
            end

            # TODO: Hacky way of making the score worth only half as much. I think it'd probably be better if we
            # tweaked score updater average code.
            result *= TODO_RESULT_WEIGHT

            score(link.url, result)
          end
        end
      end # Freshness
    end # Source
  end # Score
end # Oursignal
