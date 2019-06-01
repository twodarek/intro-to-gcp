FROM ruby:2.3.4

MAINTAINER Thomas Wodarek <twodarek@thomaswodarek.com>

ENV RACK_ENV production
ENV MAIN_APP_FILE web.rb
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install build-essential libmysqlclient-dev -y

RUN mkdir -p /rb

ENV BUNDLE_PATH /rb
ENV GEM_PATH /rb
ENV GEM_HOME /rb

RUN gem update
# RUN gem install bundler
RUN gem install bundler -v '< 2'

RUN echo "Starting you sinatra build."
RUN mkdir -p /wodarek/secret/
RUN mkdir -p /wodarek/videos/
WORKDIR /wodarek/

ADD Gemfile /wodarek/
RUN bundler install

ADD startup.sh /wodarek/
ADD web.rb /wodarek/
ADD config.ru /wodarek/
ADD secret/service_user.json /wodarek/secret/

CMD ["/bin/bash", "/wodarek/startup.sh"]
