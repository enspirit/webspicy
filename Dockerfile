FROM ruby:2.7

WORKDIR /home/app
VOLUME /home/app

RUN gem install -v 0.15.0 webspicy

CMD webspicy /home/app/config.rb
