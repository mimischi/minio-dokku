FROM minio/minio:latest
EXPOSE 9000
RUN adduser -D -g "" dokku
USER dokku
WORKDIR /home/dokku/
CMD server storage
