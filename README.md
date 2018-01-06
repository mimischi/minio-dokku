![](header.png)

[![Minio Version](https://img.shields.io/badge/Minio-latest-blue.svg)]() [![Dokku Version](https://img.shields.io/badge/Dokku-v0.11.2-blue.svg)]()

# Run Minio on Dokku

## Perquisites

### What is Minio?

Minio is an object storage server, and API compatible with Amazon S3 cloud
storage service. Read more at the [minio.io](https://www.minio.io/) website.

### What is Dokku?

[Dokku](http://dokku.viewdocs.io/dokku/) is the smallest PaaS implementation
you've ever seen - _Docker powered mini-Heroku_.

### Requirements
* A working [Dokku host](http://dokku.viewdocs.io/dokku/getting-started/installation/)

# Setup

**Note:** We are going to use the domain `minio.example.com` for demonstration
purposes. Make sure to replace it to your domain name.

## Create the app
Log onto your Dokku Host to create the Minio app:

```bash
dokku apps:create minio
```

## Configuration

### Setting access keys

Minio uses two access keys (`ACCESS_KEY` and `SECRET_KEY`) for authentication
and object management. The following commands sets a random strings for each
access key.

```bash
dokku config:set minio MINIO_ACCESS_KEY=$(echo `openssl rand -base64 45` | tr -d \=+ | cut -c 1-20)
dokku config:set minio MINIO_SECRET_KEY=$(echo `openssl rand -base64 45` | tr -d \=+ | cut -c 1-32)
```

To login in the browser or via API, you will need to supply both the
`ACCESS_KEY` and `SECRET_KEY`. You can retrieve these at any time while logged
in on your host running dokku via `dokku config minio`.

**Note:** If you do not set these keys, Minio will generate them during startup
and output them to the log (check if via `dokku logs minio`). You will still
need to set them manually.


## Persistent storage

To persists uploaded data between restarts, we create a folder on the host
machine, add write permissions to the user defined in `Dockerfile` and tell
Dokku to mount it to the app container.

```bash
sudo mkdir -p /var/lib/dokku/data/storage/minio
sudo chown 32769:32769 /var/lib/dokku/data/storage/minio
dokku storage:mount minio /var/lib/dokku/data/storage/minio:/home/dokku/data
```

## Domain setup

To get the routing working, we need to apply a few settings. First we set
the domain.

```bash
dokku domains:set minio minio.example.com
```

The parent Dockerfile, provided by the [Minio
project](https://github.com/minio/minio), exposes port `9000` for web requests.
Dokku will set up this port for outside communication, as explained in [its
documentation](http://dokku.viewdocs.io/dokku/advanced-usage/proxy-management/#proxy-port-mapping).
Because we want Minio to be available on the default port `80` (or `443` for
SSL), we need to fiddle around with the proxy settings.

First add the correct port mapping for this project as defined in the parent
`Dockerfile`.

```bash
dokku proxy:ports-add minio http:80:9000
```

Next remove the proxy mapping added by Dokku.

```bash
dokku proxy:ports-remove minio http:80:5000
```

## Push Minio to Dokku

### Grabbing the repository

First clone this repository onto your machine.

#### Via SSH

```bash
git clone git@github.com:slypix/minio-dokku.git
```

#### Via HTTPS

```bash
git clone https://github.com/slypix/minio-dokku.git
```

### Set up git remote

Now you need to set up your Dokku server as a remote.

```bash
git remote add dokku dokku@example.com:minio
```

### Push Minio

Now we can push Minio to Dokku (_before_ moving on to the [next part](#domain-and-ssl-certificate)).

```bash
git push dokku master
```

## SSL certificate

Last but not least, we can go an grab the SSL certificate from [Let's
Encrypt](https://letsencrypt.org/).

```bash
dokku config:set --no-restart minio DOKKU_LETSENCRYPT_EMAIL=you@example.com
dokku letsencrypt minio
```

## Wrapping up

Your Minio instance should now be available on `[https://minio.example.com](https://minio.example.com)`.
