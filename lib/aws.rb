module GitLfsS3
  module AwsHelpers
    def s3
      @s3 ||= Aws::S3::Client.new
    end

    def bucket_name
      ENV['S3_BUCKET']
    end

    def bucket
      @bucket ||= Aws::S3::Bucket.new(name: bucket_name, client: s3)
    end

    def object_data(oid)
      bucket.object("data/#{oid}")
    end

    def aws_secret_access_key
      ENV['AWS_SECRET_ACCESS_KEY']
    end
  end
end
