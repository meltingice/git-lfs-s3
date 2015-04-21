module GitLfsS3
  module UploadService
    class UploadRequired < Base
      def self.should_handle?(req, object)
        !object.exists? || object.size != req['size']
      end

      def response
        {
          '_links' => {
            'upload' => {
              'href' => upload_destination,
              'header' => upload_headers
            },
            'verify' => {
              'href' => File.join(server_url, 'verify')
            }
          }
        }
      end

      def status
        202
      end

      def to_curl
        curl = ["curl -XPUT"]
        curl << "-T \"{{file}}\""
        upload_headers.each do |k, v|
          curl << "-H \"#{k}: #{v}\""
        end
        curl << upload_destination

        curl.join(' ')
      end

      private

      def upload_destination
        object.presigned_url(:put)
      end

      def upload_headers
        {'content-type' => ''}
      end
    end
  end
end
