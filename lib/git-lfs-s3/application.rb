module GitLfsS3
  class Application < Sinatra::Application
    include AwsHelpers

    class << self
      attr_reader :auth_callback

      def on_authenticate(&block)
        @auth_callback = block
      end

      def authentication_enabled?
        !auth_callback.nil?
      end

      def perform_authentication(username, password, is_safe)
        auth_callback.call(username, password, is_safe)
      end
    end

    configure do
      disable :sessions
      enable :logging
    end

    helpers do
      def logger
        settings.logger
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && self.class.auth_callback.call(
        @auth.credentials[0], @auth.credentials[1], request.safe?
      )
    end

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Invalid username or password"])
      end
    end

    get '/' do
      "Git LFS S3 is online."
    end

    get "/objects/:oid", provides: 'application/vnd.git-lfs+json' do
      object = object_data(params[:oid])

      if object.exists?
        status 200
        resp = {
          'oid' => params[:oid],
          'size' => object.size,
          '_links' => {
            'self' => {
              'href' => File.join(settings.server_url, 'objects', params[:oid])
            },
            'download' => {
              # TODO: cloudfront support
              'href' => object_data(params[:oid]).presigned_url(:get)
            }
          }
        }

        body MultiJson.dump(resp)
      else
        status 404
        body MultiJson.dump({message: 'Object not found'})
      end
    end

    def public_read_grant
      grantee = Aws::S3::Types::Grantee.new(
        display_name: nil, email_address: nil, id: nil, type: nil,
        uri: "http://acs.amazonaws.com/groups/global/AllUsers")
      Aws::S3::Types::Grant.new(grantee: grantee, permission: "READ")
    end

    before do
      pass if request.safe? and settings.public_server
      protected!
    end

    post "/objects", provides: 'application/vnd.git-lfs+json' do
      logger.debug headers.inspect
      service = UploadService.service_for(request.body)
      logger.debug service.response
      
      status service.status
      body MultiJson.dump(service.response)
    end

    post '/verify', provides: 'application/vnd.git-lfs+json' do
      data = MultiJson.load(request.body.tap { |b| b.rewind }.read)
      object = object_data(data['oid'])
      if not object.exists?
        status 404
      end
      if settings.public_server and settings.ceph_s3
        if object.acl.grants.include?(public_read_grant)
          object.acl.put(acl: "public-read")
        end
      end
      if object.size == data['size']
        status 200
      end
    end
  end
end
