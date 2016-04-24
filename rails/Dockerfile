FROM ruby:2.2
MAINTAINER Alex Ulianytskyi <a.ulyanitsky@gmail.com>

# nginx key
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62

RUN curl --silent --location http://nginx.org/keys/nginx_signing.key | apt-key add -

# add nginx mainline repository
COPY nginx-mainline.list /etc/apt/sources.list.d/nginx.list

# install NodeJs 0.12
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -

# packages
RUN apt-get -y -q install nginx nodejs mysql-client postgresql-client \
      python-pip python-dev --no-install-recommends && \
    apt-get clean

# aws cli & eb cli
RUN pip install --upgrade awscli awsebcli

# pre-install gems
RUN gem install slack-notifier foreman puma pg mysql2 rails

# nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
COPY nginx-sites.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV APP_HOME /usr/src/app

RUN mkdir -p public log log/nginx tmp tmp/sockets tmp/pids tmp/cache

COPY 502.html 503.html public/

# add default unicorn config
COPY puma.rb config/

# add default foreman config
COPY Procfile Procfile

# run necessary steps via inherited Dockerfile
ONBUILD COPY config/Gemfile $APP_HOME/
ONBUILD COPY Gemfile.lock $APP_HOME/
ONBUILD RUN bundle install --jobs 8 --retry 3
ONBUILD COPY . $APP_HOME
ONBUILD RUN chown www-data:www-data -R $APP_HOME

EXPOSE 80 443
CMD foreman start
