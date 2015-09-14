# Git LFS S3

A [Git LFS](https://git-lfs.github.com/) server that stores your large Git files on S3.

It works by generating a presigned URL that the Git LFS client can use to upload directly to S3. It also provides download URLs that allow Git clients to download directly from S3. No data is proxied through the Git LFS server.

## Installation

Git LFS S3 is available on RubyGems.

``` bash
gem install git-lfs-s3
```

Or add it to your Gemfile if you wish to bundle it as a part of another application.

``` ruby
gem 'git-lfs-s3'
```

## Configuration

### Standalone

All configuration is done via environment variables. All of these configuration variables must be set.

* `AWS_REGION` - the region where your S3 bucket is.
* `AWS_ACCESS_KEY_ID` - your AWS access key.
* `AWS_SECRET_ACCESS_KEY` - your AWS secret key.
* `S3_BUCKET` - the bucket you wish to use for LFS storage. While not required, I recommend using a dedicated bucket for this.
* `LFS_SERVER_URL` - the URL where this server can be reached; needed to fetch download URLs.

You can (and should) also set authentication information. When you push for the first time from git, you will be prompted to enter a username and password when authentication is enabled. You can configure these with environment variables as well.

* `USERNAME` - the login username.
* `PASSWORD` - the login password.

### Bundled

If you are bundling the service inside of another application, such as Rails, or a different server of your choosing, you can set the configuration directly on `GitLfsS3::Application`. See [bin/git-lfs-s3](https://github.com/meltingice/git-lfs-s3/blob/master/bin/git-lfs-s3) for an example.

You can also hook the authentication into your own service this way. For example:

``` ruby
GitLfsS3::Application.on_authenticate do |username, password, is_safe|
  if is_safe
    true
  else
    user = User.find(username: username)
    user.verify_password(password)
  end
end
```

The logger can be configured as well. This is especially handy if you want to hook it into your Rails logger:

``` ruby
GitLfsS3::Application.set :logger, Rails.logger
```

### Git Setup

If you are new to Git LFS, make sure you read the [Getting Started](https://git-lfs.github.com/) guide first. Once that's done, you can configure your Git client to use this server by creating a `.gitconfig` file in the root of your repository and adding this config, but with your server address:

``` git
[lfs]
    url = "http://yourserver.com"
```

Once that is done, you can tell Git LFS to track files with `git lfs track "*.psd"`, for example.

## Running

This repository contains an executable that will run a basic WEBrick server. Since this service is so lightweight, that's likely all you'll need. The port will default to 8080, but can be configured with an environment variable.

``` bash
PORT=4000 git-lfs-s3
```

However, because this is a Sinatra application, it can also be mounted within other Rack based projects or other Rack-based servers such as Unicorn or Puma. For example, if you wanted to add this to your Rails project, configure `GitLfsS3` in an initializer, and add this your routes:

``` ruby
mount GitLfsS3::Application => '/lfs'
```

## TODO

* Cloudfront support
