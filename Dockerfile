FROM enspirit/webspicy:builder as builder

RUN gem build -o /tmp/webspicy.gem webspicy.gemspec && \
  gem install /tmp/webspicy.gem

FROM ruby:2.7-alpine

WORKDIR /home/app

COPY --from=builder /usr/local/bundle /usr/local/bundle

ENTRYPOINT [ "webspicy" ]
