FROM ruby:2.2
MAINTAINER Alex Ulianytskyi <a.ulyanitsky@gmail.com>

RUN apt-get update && \
    apt-get -y -q install build-essential python-dev python-pip nodejs postgresql-client --no-install-recommends && \
    apt-get clean

RUN pip install awscli awsebcli

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

# For wantedly/pretty-slack-notify
RUN gem install slack-notifier

RUN mkdir -p /usr/src/app && \
    useradd app --home /usr/src/app && \
    chown app:app -R /usr/src/app

WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install
ONBUILD COPY . /usr/src/app
ONBUILD USER root
ONBUILD RUN chown app:app -R /usr/local/bundle
ONBUILD RUN chown app:app -R /usr/src/app
ONBUILD USER app

VOLUME /usr/local/bundle
VOLUME /usr/src/app/tmp

EXPOSE 3000
CMD bundle exec rails server -b 0.0.0.0
