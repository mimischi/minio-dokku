FROM minio/minio:latest
EXPOSE 9000
USER dokku
WORKDIR /home/dokku/
CMD server storage
