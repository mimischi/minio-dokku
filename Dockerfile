FROM minio/minio:latest

# Add user dokku with an individual UID
RUN adduser -D -u 32767 -g dokku dokku
USER dokku

# Create data directory for the user, where we will keep the data
RUN mkdir -p /home/dokku/data

# Run the server and point to the created directory
CMD ["server", "/home/dokku/data"]
