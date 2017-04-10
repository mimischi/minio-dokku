![](header.png)

[![Minio Version](https://img.shields.io/badge/Minio-v2017--03--16T21%3A50%3A32Z-blue.svg)]()  [![Dokku Version](https://img.shields.io/badge/Dokku-v0.9.2-blue.svg)]()  [![Docker Automated buil](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)]()

# Run Minio on Dokku
## What is Minio
Minio is an object storage server, and API compatible with Amazon S3 cloud storage service.
Read more at the [minio.io](https://www.minio.io/) website.

## What is Dokku
The smallest PaaS implementation you've ever seen - _Docker powered mini-Heroku_
Read more at the [Dokku](http://dokku.viewdocs.io/dokku/) website

## How to Setup

### Requirements
* A working Dokku host - [(Installation Instructions)](http://dokku.viewdocs.io/dokku/getting-started/installation/)

### Create the app
Log onto your Dokku Host to create the minio app
```bash
dokku apps:create minio
```

### Set Environment Variables
minio uses an **access key** and **secret key** for login, and object management. You can set custom keys with /[Environment Variables](http://dokku.viewdocs.io/dokku/configuration/environment-variables/)/. if keys aren't set, minio server will generate them.
```
dokku config:set minio MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
dokku config:set minio MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/EXAMPLEKEY
```
**Note:** you can find the minio generated keys by checking app logs, with: `dokku logs minio`

### Download Dockerfile
from your local machine clone this repo
```
git clone https://github.com/slypix/minio-dokku.git
cd minio-dokku
```

### Add Dokku remote, and Deploy
```
git remote add dokku dokku@<your-dokku-host.com>:minio
git push dokku master
```

### Add Persistent/External Storage
minio will use docker’s container (non-persistent) directory `/home/dokku/data`,  if you need to (stop_rebuild_restart) the app, you will loose all data from that directory. So we can map a host directory to `/var/lib/dokku/data/storage/minio` with [Dokku Storage](http://dokku.viewdocs.io/dokku/advanced-usage/persistent-storage/) to make it persistent. 

```
# creating storage for the app 'minio'
mkdir -p  /var/lib/dokku/data/storage/minio

# set permissions for storage directory
chown -R dokku:dokku /var/lib/dokku/data/storage/minio
chmod 667 /var/lib/dokku/data/storage/minio

# mount the directory into your container's /app/storage directory, relative to root
dokku storage:mount minio /var/lib/dokku/data/storage/minio:/home/dokku/data

# restart minio app
dokku ps:restart minio
```
