FROM minio/minio:latest

# Add bash
RUN apk update && apk add bash

# Install minio client
RUN wget https://dl.minio.io/client/mc/release/linux-amd64/mc
RUN mv mc /bin
RUN chmod +x /bin/mc

# Add user dokku with an individual UID
RUN adduser -u 32769 -m -U dokku
USER dokku

# Create data directory for the user, where we will keep the data
RUN mkdir -p /home/dokku/data

# Add custom nginx.conf template for Dokku to use
WORKDIR /app
ADD nginx.conf.sigil .

CMD ["minio", "server", "/home/dokku/data", "--console-address", ":9001"]
