require "git-lfs-s3/services/ceph_presigner"

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

      private

      def upload_destination
        if ceph_s3
          GitLfsS3::CephPresignerService::signed_url(object)
        else
          if GitLfsS3::Application.settings.public_server
            object.presigned_url(:put, acl: 'public-read')
          else
            object.presigned_url(:put)
          end
        end
      end

      def upload_headers
        {'content-type' => ''}
      end
    end
  end
end
