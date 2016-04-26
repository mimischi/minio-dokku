# Run Minio on Dokku

## What is Minio
Minio is an object storage server. an API compatible with Amazon S3 cloud storage service.
Read more at the [minio.io](https://www.minio.io/) website.

## What is Dokku
The smallest PaaS implementation you've ever seen - _Docker powered mini-Heroku_
Read more at the [Dokku](http://dokku.viewdocs.io/dokku/) website

## Minio-Dokku image info
The image file is based on `alpine:3.3`, with the following added to it:
- user dokku
- minio 32-bit Intel from [https://dl.minio.io/server/minio/release/linux-386/minio](https://dl.minio.io/server/minio/release/linux-386/minio)
- storage directory

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
- A working Dokku server - [(Installation Instructions)](http://dokku.viewdocs.io/dokku/installation/)

### Create the app
Log onto your Dokku Host to create the minio app
```bash
dokku apps:create minio
```

### Set Environment Variables
minio uses an **access key** and **secret key** for login and object management. Although minio can generate it's own keys you may want to set your own custom keys. *more details on dokku [Environment Variables](https://github.com/dokku/dokku/blob/master/docs/configuration-management.md)*.
```
dokku config:set minio MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
dokku config:set minio MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/EXAMPLEKEY
```
Note: if you didn't set your keys, you can find them by checking app logs, with: `dokku logs minio`

### Create your Dockerfile
from your local machine create your app folder and `Dockerfile`
```
mkdir minio && cd minio
touch Dockerfile
```
 Paste the following in your Dockerfile using the editor of your choice
```
FROM slypix/minio-dokku:1.0
EXPOSE 9000
WORKDIR /home/dokku/
CMD ./minio server storage
```

### Add the Dokku remote, and Deploy
```
git init
git add .
git commit -m "Dockerfile config for minio server"
git remote add dokku dokku@youdokkuhost.com:minio
git push dokku master
```

### Add Persistent/External Storage
Currently minio is using the directory `\home\dokku\storage` inside the docker image, we can map a host directory to  `storage` with [Dokku Core Storage Plugin](https://github.com/dokku/dokku/blob/master/docs/dokku-storage.md)

you can use an existing directory or create a new one
_make sure you change to dokku user before you create a new directory_
```
su dokku
mkdir /home/dokku/minio/data
```
Mount directory example:
```
dokku storage:mount minio /home/dokku/minio/data:/home/dokku/storage
dokku ps:restart minio
```
