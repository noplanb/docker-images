FROM ruby:2.2
MAINTAINER Alex Ulianytskyi <a.ulyanitsky@gmail.com>

# Packages
RUN apt-get update && \
    apt-get -y -q install build-essential python-dev python-pip \
    sudo nginx nodejs postgresql-client --no-install-recommends && \
    apt-get clean

# AWS CLI & EB CLi
RUN pip install awscli awsebcli

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

# Nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx
# Add default nginx config
COPY nginx-sites.conf /etc/nginx/sites-enabled/default

# For wantedly/pretty-slack-notify
RUN gem install slack-notifier foreman puma

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

RUN mkdir -p public log tmp tmp/sockets tmp/pids tmp/cache

# Add default unicorn config
COPY puma.rb /usr/src/app/config/puma.rb

# Add default foreman config
COPY Procfile /usr/src/app/Procfile

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install
ONBUILD COPY . /usr/src/app
ONBUILD RUN rake assets:precompile
ONBUILD RUN chown www-data:www-data -R /usr/src/app

EXPOSE 8000
CMD foreman start
