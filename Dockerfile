FROM enspirit/webspicy:builder as builder

RUN gem build -o /tmp/webspicy.gem webspicy.gemspec && \
  gem install /tmp/webspicy.gem

FROM ruby:2.7-alpine

RUN addgroup --gid 1000 --system app \
  && adduser --uid 1000 --system -G app app \
  && mkdir -p /home/app \
  && chown app:app -R /home/app

WORKDIR /home/app

COPY --from=builder /usr/local/bundle /usr/local/bundle

USER app

ENTRYPOINT [ "webspicy" ]
