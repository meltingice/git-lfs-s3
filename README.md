# Git LFS S3

A [Git LFS](https://git-lfs.github.com/) server that stores your large Git files on S3.

It works by generating a presigned URL that the Git LFS client can use to upload directly to S3. It also provides download URLs that allow Git clients to download directly from S3. No data is proxied through the Git LFS server.

## Configuration

Currently, all configuration is done via environment variables. All configuration variables must be set.

* `AWS_REGION` - the region where your S3 bucket is.
* `AWS_ACCESS_KEY_ID` - your AWS access key.
* `AWS_SECRET_ACCESS_KEY` - your AWS secret key.
* `S3_BUCKET` - the bucket you wish to use for LFS storage. While not required, I recommend using a dedicated bucket for this.
* `SERVER_URL` - the URL where this server can be reached; needed to fetch download URLs.

## Running

This repository includes a Procfile. If you have `foreman` installed, simply run `foreman start`.

Because this is a Sinatra application, it can also be mounted within other Rack based projects (such as Rails). For example:

``` ruby
mount GitLfsS3::Application => '/lfs'
```

## TODO

* Git authentication
* Cloudfront support
