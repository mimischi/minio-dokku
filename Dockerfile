FROM minio/minio:latest
EXPOSE 9000
RUN adduser -D -g "" dokku
USER dokku
RUN mkdir /home/dokku/data
CMD ["server", "/home/dokku/data"]
