FROM minio/minio:latest

# Add bash
RUN apk update && apk add bash

# Install minio client
RUN wget https://dl.minio.io/client/mc/release/linux-amd64/mc
RUN mv mc /bin
RUN chmod +x /bin/mc

# Add user dokku with an individual UID
RUN adduser -D -u 32769 -g dokku dokku
USER dokku

# Create data directory for the user, where we will keep the data
RUN mkdir -p /home/dokku/data

# Run the server and point to the created directory
CMD ["server", "/home/dokku/data"]
