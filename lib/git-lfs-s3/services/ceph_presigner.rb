require 'base64'
require 'digest/sha1'
require 'openssl'
require 'uri'

module GitLfsS3
  module CephPresignerService
    extend self
    extend AwsHelpers

    def signed_url(obj)
      expire_at = (DateTime.now + 1).strftime("%s")
      secret_access_key = Aws.config[:secret_access_key]
      access_key_id = Aws.config[:access_key_id]
      endpoint = Aws.config[:endpoint]
      digest = OpenSSL::Digest.new('sha1')
      can_string = "PUT\n\n\n#{expire_date}\n/#{obj.bucket_name}/#{obj.key}"
      hmac = OpenSSL::HMAC.digest(digest, secret_access_key, can_string)
      signature = URI.escape(Base64.encode64(hmac).strip, /[\+=?@$&,\/:;\?]/)
      "#{endpoint}/#{obj.bucket_name}/#{obj.key}?Signature=#{signature}&AWSAccessKeyId=#{access_key_id}&Expires=#{expire_date}"
    end
  end
end
