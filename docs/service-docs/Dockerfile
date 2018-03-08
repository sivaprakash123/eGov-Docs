FROM egovio/ci-jekyll:v1.0
ENV WEBDIR=/var/www/service-docs/
RUN mkdir -p ${WEBDIR}
COPY entrypoint.sh /entrypoint.sh
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD ["/entrypoint.sh"]
