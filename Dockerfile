FROM enspirit/webspicy:builder AS builder

RUN gem build -o /tmp/webspicy.gem webspicy.gemspec && \
  gem install /tmp/webspicy.gem

# Rack 3 dropped the `rackup` executable into its own gem, and webrick is no
# longer a default gem. Both are what the mocker and inferer images boot with.
# They stay out of the gemspec on purpose: rackup requires rack >= 3, and the
# gem itself leaves the rack major up to the application under test.
RUN gem install --no-document rackup webrick

FROM ruby:4.0-alpine

RUN addgroup --gid 1000 --system app \
  && adduser --uid 1000 --system -G app app \
  && mkdir -p /home/app \
  && chown app:app -R /home/app

WORKDIR /home/app

COPY --from=builder /usr/local/bundle /usr/local/bundle

USER app

ENTRYPOINT [ "webspicy" ]
