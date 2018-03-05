#!/bin/sh
cd /var/www/service-docs/
git clone https://github.com/sivaprakash123/eGov-Docs.git
cd docs/service-docs
jekyll serve
