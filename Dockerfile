FROM slypix/minio-dokku:1.0
EXPOSE 9000
USER dokku
WORKDIR /home/dokku/
CMD ./minio server storage
