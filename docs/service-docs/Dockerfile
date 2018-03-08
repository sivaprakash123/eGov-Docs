FROM egovio/ci-jekyll:v1.0
RUN apk --update add nginx
RUN mkdir -p /run/nginx
WORKDIR /srv/jekyll
COPY entrypoint.sh /entrypoint.sh
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD ["/entrypoint.sh"]
