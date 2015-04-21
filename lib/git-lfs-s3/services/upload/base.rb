module GitLfsS3
  module UploadService
    class Base
      include AwsHelpers
      
      attr_reader :req, :object

      def initialize(req, object)
        @req = req
        @object = object
      end

      def response
        raise "Override"
      end

      def status
        raise "Override"
      end

      private

      def server_url
        GitLfsS3::Application.settings.server_url
      end
    end
  end
end
