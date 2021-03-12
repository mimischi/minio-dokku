FROM minio/minio:latest

# Add user dokku with an individual UID
RUN adduser -u 32769 -m -U dokku
USER dokku

# Create data directory for the user, where we will keep the data
RUN mkdir -p /home/dokku/data

# Add custom nginx.conf template for Dokku to use
WORKDIR /app
ADD nginx.conf.sigil .

# Run the server and point to the created directory
CMD ["server", "/home/dokku/data"]
