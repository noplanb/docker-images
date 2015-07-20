FROM rails:4.2.3
MAINTAINER Alex Ulianytskyi <a.ulyanitsky@gmail.com>

# For asux/elastic-beanstalk-deploy
RUN apt-get -y -q update && apt-get -y -q install build-essential python-dev python-pip && apt-get clean
RUN pip install awscli awsebcli

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

# For wantedly/pretty-slack-notify
RUN gem install slack-notifier

RUN mkdir -p /usr/src/app && \
    useradd app --home /usr/src/app && \
    chown app:app -R /usr/src/app

WORKDIR /usr/src/app

VOLUME /usr/local/bundle
ONBUILD RUN chown app:app -R /usr/local/bundle

ONBUILD USER app
ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install
ONBUILD COPY . /usr/src/app
ONBUILD USER root
ONBUILD RUN chown app:app -R /usr/src/app
ONBUILD USER app
ONBUILD VOLUME /usr/src/app/tmp

EXPOSE 3000
CMD bundle exec rails server -b 0.0.0.0
