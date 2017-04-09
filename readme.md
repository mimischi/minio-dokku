# Run Minio on Dokku

## What is Minio
Minio is an object storage server, and API compatible with Amazon S3 cloud storage service.
Read more at the [minio.io](https://www.minio.io/) website.

## What is Dokku
The smallest PaaS implementation you've ever seen - _Docker powered mini-Heroku_
Read more at the [Dokku](http://dokku.viewdocs.io/dokku/) website

## Minio-Dokku image info
minio-dokku uses the `alpine:3.3` docker image, with the following added to it:
- **dokku user:** `adduser dokku`
- **curl:** `apk add --update curl`
- **minio 32-bit Intel:** `curl` [https://dl.minio.io/server/minio/release/linux-386/minio](https://dl.minio.io/server/minio/release/linux-386/minio) ` > /home/dokku/minio`
- **storage directory:** `mkdir /home/dokku/storage`

```
Alpine Linux
  |--/usr
  |--/other linux files
  |--/home
       |- dokku
           |--minio
           |--storage
```
---

## How to Setup

### Requirements
- A working Dokku host - [(Installation Instructions)](http://dokku.viewdocs.io/dokku/installation/)

### Create the app
Log onto your Dokku Host to create the minio app
```bash
dokku apps:create minio
```

### Set Environment Variables
minio uses an **access key** and **secret key** for login, and object management. You can set custom keys with _[Environment Variables](https://github.com/dokku/dokku/blob/master/docs/configuration-management.md)_. if keys aren't set, minio server will generate them. 
```
dokku config:set minio MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
dokku config:set minio MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/EXAMPLEKEY
```
**Note:** you can find the minio generated keys by checking app logs, with: `dokku logs minio`

### Create your Dockerfile
from your local machine create your app folder and `Dockerfile`
```
mkdir minio && cd minio
touch Dockerfile
```
Add the following in your Dockerfile:
```
FROM slypix/minio-dokku:1.0
EXPOSE 9000
USER dokku
WORKDIR /home/dokku/
CMD ./minio server storage
```

### Add Dokku remote, and Deploy
```
git add Dockerfile
git commit -m "Dockerfile config for minio server"
git remote add dokku dokku@youdokkuhost.com:minio
git push dokku master
```

### Add Persistent/External Storage
Currently minio uses docker image directory `\home\dokku\storage`, we can map a host directory to `\home\dokku\storage` with [Dokku Core Storage Plugin](https://github.com/dokku/dokku/blob/master/docs/dokku-storage.md)

you can use an existing directory or create a new one
_make sure you change to dokku user before you create a new directory_
```
su dokku
mkdir /home/dokku/minio/data
```
Mount directory and restart app:
```
dokku storage:mount minio /home/dokku/minio/data:/home/dokku/storage
dokku ps:restart minio
```
