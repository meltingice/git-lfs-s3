require 'sinatra/base'
require 'aws-sdk'
require 'multi_json'

Dir['./lib/**/*.rb'].each { |f| require f }

module GitLfsS3
  class Application < Sinatra::Application
    include AwsHelpers
    set :sessions, false

    def server_url
      ENV['SERVER_URL']
    end

    # before do
    #   raise headers['Accept'].inspect
    #   if headers['Accept'] != 'application/vnd.git-lfs+json'
    #     halt 406, {'Content-Type' => 'text/plain'}, 'Server only accepts application/vnd.git-lfs+json'
    #   end
    # end

    get "/objects/:oid", provides: 'application/vnd.git-lfs+json' do
      object = object_data(params[:oid])

      if object.exists?
        status 200
        resp = {
          'oid' => params[:oid],
          'size' => object.size,
          '_links' => {
            'self' => {
              'href' => File.join(server_url, 'objects', params[:oid])
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

    post "/objects", provides: 'application/vnd.git-lfs+json' do
      service = UploadService.service_for(request.body)
      
      status service.status
      body MultiJson.dump(service.response)
    end

    post '/verify', provides: 'application/vnd.git-lfs+json' do
      data = MultiJson.load(request.body.tap { |b| b.rewind }.read)
      object = object_data(data['oid'])

      if object.exists? && object.size == data['size']
        status 200
      else
        status 404
      end
    end
  end
end
