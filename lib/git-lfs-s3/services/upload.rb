require "git-lfs-s3/services/upload/base"
require "git-lfs-s3/services/upload/object_exists"
require "git-lfs-s3/services/upload/upload_required"

module GitLfsS3
  module UploadService
    extend self
    extend AwsHelpers

    MODULES = [
      ObjectExists,
      UploadRequired
    ]

    def service_for(data)
      req = MultiJson.load data.tap { |d| d.rewind }.read
      object = object_data(req['oid'])

      MODULES.each do |mod|
        return mod.new(req, object) if mod.should_handle?(req, object)
      end

      nil
    end
  end
end
