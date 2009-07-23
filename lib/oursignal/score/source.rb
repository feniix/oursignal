require 'oursignal/job'
require 'uri/sanatize'
require 'open-uri'
require 'zlib'

module Oursignal
  module Score

    class Source < Job
      def poll
        Merb.logger.info("#{name}\tupdating cache")
        http_read(http_uri)
      end

      def uri(address, params = nil)
        uri = Addressable::URI.parse(address)
        uri.query_values = params if params && uri
        uri
      end

      def score(url, score)
        cache       = ::Score.first_or_new_by_url(url, self.class.name)
        cache.score = score
        result      = cache.save
        Merb.logger.debug("%s\t%d\t%s" % [cache.source, cache.score, cache.url])
        result
      end

      protected
        # Read http_uri and return the response body.
        def http_read(uri)
          content, encoding = '', ''
          begin
            res = open(uri.to_s, http_read_options)
            if res.meta['content-encoding'] == 'gzip'
              encoding = 'GZ '
              gz       = Zlib::GzipReader.new(res)
              content  = gz.read
              gz.close
            # TODO: when 'deflate'
            else
              content = res.read
            end
          rescue URI::InvalidURIError
            content = ''
          end
          content
        end

        # Options that will be passed to open() when requesting the data.
        def http_read_options
          {'User-Agent' => Link::USER_AGENT, 'Accept-Encoding' => 'gzip'}
        end

        # Generate a URI, Addressable::URI or just a string URI to read from.
        def http_uri
          raise NotImplementedError
        end
    end # Source
  end # Score
end # Oursignal

