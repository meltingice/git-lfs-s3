module GitLfsS3
  module AwsHelpers
    def s3
      @s3 ||= Aws::S3::Client.new({
        region: aws_region,
        access_key_id: aws_access_key_id,
        secret_access_key: aws_secret_access_key
      })
    end

    def bucket_name
      GitLfsS3::Application.settings.s3_bucket
    end

    def bucket
      @bucket ||= Aws::S3::Bucket.new(name: bucket_name, client: s3)
    end

    def object_data(oid)
      bucket.object("data/#{oid}")
    end

    def aws_region
      GitLfsS3::Application.settings.aws_region
    end

    def aws_access_key_id
      GitLfsS3::Application.settings.aws_access_key_id
    end

    def aws_secret_access_key
      GitLfsS3::Application.settings.aws_secret_access_key
    end
  end
end
