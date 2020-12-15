FROM ruby:2.7-alpine as builder

RUN apk add alpine-sdk

WORKDIR /gem
COPY . ./
RUN bundle install && bundle exec rake test && \
  gem build -o /tmp/webspicy.gem webspicy.gemspec && \
  gem install /tmp/webspicy.gem

FROM ruby:2.7-alpine

WORKDIR /home/app

COPY --from=builder /usr/local/bundle /usr/local/bundle

ENTRYPOINT [ "webspicy" ]
