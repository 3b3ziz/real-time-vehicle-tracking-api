FROM ruby:2.6.5-alpine

RUN apk update && apk add  postgresql-client nodejs \
    readline readline-dev \
    libxml2 libxml2-dev libxml2-utils \
    libxslt libxslt-dev zlib-dev zlib \
    libffi-dev build-base \
    postgresql-dev \
    make gcc g++ tzdata

RUN mkdir /myapp

WORKDIR /myapp

COPY Gemfile Gemfile

COPY Gemfile.lock Gemfile.lock

RUN gem install bundler:2.0.2

RUN bundle install

COPY . .

CMD bundle exec rails s -b '0.0.0.0' -p 10000
