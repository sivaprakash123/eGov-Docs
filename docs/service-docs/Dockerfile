FROM egovio/ci-jekyll:v1.0
ENV WEBDIR=/var/www/service-docs/
RUN mkdir -p ${WEBDIR}
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
