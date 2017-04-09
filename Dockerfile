FROM minio/minio:latest
EXPOSE 9000
RUN adduser -D -g "" dokku
RUN mkdir /home/dokku/storage
USER dokku
CMD ["server", "/home/dokku/storage"]
