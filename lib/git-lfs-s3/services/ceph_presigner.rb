require 'base64'
require 'date'
require 'digest/sha1'
require 'openssl'
require 'uri'

module GitLfsS3
  module CephPresignerService
    extend self
    extend AwsHelpers
    
    def signed_url(obj)
      expire_at = (DateTime.now + 1).strftime("%s")
      secret_access_key = GitLfsS3::Application.settings.aws_secret_access_key
      access_key_id = GitLfsS3::Application.settings.aws_access_key_id
      endpoint = GitLfsS3::Application.settings.endpoint
      digest = OpenSSL::Digest.new('sha1')
      can_string = "PUT\n\napplication/octet-stream\n#{expire_at}\n/#{obj.bucket_name}/#{obj.key}"
      hmac = OpenSSL::HMAC.digest(digest, secret_access_key, can_string)
      signature = URI.escape(Base64.encode64(hmac).strip, /[\+=?@$&,\/:;\?]/)
      "#{endpoint}/#{obj.bucket_name}/#{obj.key}?Signature=#{signature}&AWSAccessKeyId=#{access_key_id}&Expires=#{expire_at}"
    end
  end
end
