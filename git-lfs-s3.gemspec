# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-lfs-s3/version'

Gem::Specification.new do |gem|
  gem.name          = "psd"
  gem.version       = GitLfsS3::VERSION
  gem.authors       = ["Ryan LeFevre"]
  gem.email         = ["meltingice8917@gmail.com"]
  gem.description   = %q{A Git LFS server that uses S3 for the storage backend.}
  gem.summary       = %q{A Git LFS server that uses S3 for the storage backend by providing presigned S3 URLs.}
  gem.homepage      = "https://github.com/meltingice/git-lfs-s3"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'aws-sdk', '~> 2'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'multi_json'
end
