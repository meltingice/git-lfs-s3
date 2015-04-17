# Git LFS S3

A [Git LFS](https://git-lfs.github.com/) server that stores your large Git files on S3.

## Configuration

Currently, all configuration is done via environment variables. All configuration variables must be set.

* `AWS_REGION` - the region where your S3 bucket is.
* `AWS_ACCESS_KEY_ID` - your AWS access key.
* `AWS_SECRET_ACCESS_KEY` - your AWS secret key.
* `S3_BUCKET` - the bucket you wish to use for LFS storage. While not required, I recommend using a dedicated bucket for this.
* `SERVER_URL` - the URL where this server can be reached.

## Running

This repository includes a Procfile. If you have `foreman` installed, simply run `foreman start`.

Because this is a Sinatra application, it can also be mounted within other Rack based projects (such as Rails).
