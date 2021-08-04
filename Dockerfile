ARG VERSION=latest
FROM mongo:${VERSION}
COPY ./docker-entrypoint.sh ./rs-initiate.sh ./
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["mongod", "--bind_ip_all", "--replSet=rs0"]