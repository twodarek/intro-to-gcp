#!/bin/bash

mkdir -p /var/log/nginx/
touch /var/log/nginx/access.log
touch /var/log/nginx/error.log
tail -f /var/log/nginx/access.log &
tail -f /var/log/nginx/error.log &
nginx -g "daemon off;"