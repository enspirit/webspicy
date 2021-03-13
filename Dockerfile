FROM ruby:2.7-alpine as builder

RUN apk add alpine-sdk

WORKDIR /gem

COPY Gemfile webspicy.gemspec ./
COPY lib/webspicy/version.rb ./lib/webspicy/version.rb
RUN bundle install

COPY examples/restful/Gemfile ./examples/restful/Gemfile
RUN cd examples/restful && bundle install

COPY examples/failures/Gemfile ./examples/failures/Gemfile
RUN cd examples/failures && bundle install

COPY . ./

RUN bundle exec rake test && \
  gem build -o /tmp/webspicy.gem webspicy.gemspec && \
  gem install /tmp/webspicy.gem

FROM ruby:2.7-alpine

WORKDIR /home/app

COPY --from=builder /usr/local/bundle /usr/local/bundle

ENTRYPOINT [ "webspicy" ]
