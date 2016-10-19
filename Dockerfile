FROM alpine

WORKDIR /app

RUN apk update && \
  apk upgrade && \
  apk --update add git ruby ruby-rake ruby-bundler ruby-rdoc ruby-irb

ENV AWS_REGION us-east-1
ENV LFS_SERVER_URL http://127.0.0.1

COPY . /app

EXPOSE 8080

RUN gem build git-lfs-s3.gemspec && \
  gem install ./git-lfs-s3-*.gem --no-rdoc --no-ri && \
  bundler install

CMD ruby bin/git-lfs-s3
