FROM rails:4.2.3
MAINTAINER Alex Ulianytskyi, a.ulyanitsky@gmail.com

# For asux/elastic-beanstalk-deploy
RUN apt-get -y -q update && apt-get -y -q install build-essential python-dev python-pip && apt-get clean
RUN pip install awscli awsebcli

# For wantedly/pretty-slack-notify
RUN gem install slack-notifier
