FROM ruby:2.7-alpine as builder

RUN apk add alpine-sdk
RUN gem install -v 0.15.7 webspicy

FROM ruby:2.7-alpine

WORKDIR /home/app

COPY --from=builder /usr/local/bundle /usr/local/bundle

ENTRYPOINT [ "webspicy" ]
