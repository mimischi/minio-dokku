FROM slypix/minio-dokku:1.0
EXPOSE 9000
ENV ALLOW_CONTAINER_ROOT=1
WORKDIR /home/dokku/
CMD ./minio server storage
