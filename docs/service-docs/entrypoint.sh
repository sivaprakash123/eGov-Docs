#!/bin/sh
cd /srv/jekyll/
git clone https://github.com/sivaprakash123/eGov-Docs.git
cd eGov-Docs/docs/service-docs
chown -R jekyll:jekyll /srv/jekyll/eGov-Docs/docs/service-docs
jekyll serve &
nginx -g 'daemon off;'
