ARG VERSION=latest
FROM mongo:${VERSION}
COPY rs-healthcheck.sh /usr/local/bin/
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --start-interval=1s CMD ["rs-healthcheck.sh"]
CMD ["mongod", "--bind_ip_all", "--replSet", "rs0"]
