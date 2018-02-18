FROM nginx:latest
MAINTAINER Thomas Wodarek <thomas@wodarek.com>

RUN rm /etc/nginx/conf.d/default.conf
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./sites-enabled/app/app.conf /etc/nginx/conf.d/
ADD ./startup.sh /nginx/conf/
ADD ./static/ /usr/share/static