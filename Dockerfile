FROM minio/minio:latest
EXPOSE 9000
RUN adduser -D -g "" dokku
USER dokku
RUN mkdir /home/dokku/storage
WORKDIR /home/dokku/
CMD ["server /home/dokku/storage"]
