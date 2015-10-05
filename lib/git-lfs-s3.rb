require 'sinatra/base'
require 'aws-sdk'
require 'multi_json'
require 'webrick'
require 'webrick/https'
require 'openssl'

require "git-lfs-s3/aws"
require "git-lfs-s3/services/upload"
require "git-lfs-s3/application"
