Docker base image: Rails + Nginx + Puma
=======================================

Docker base image for [Rails](http://rubyonrails.org) runned with [Nginx](http://nginx.org) and [Puma](http://puma.io) prepared for deploy on [AWS Elasticbeanstalk](http://aws.amazon.com/ru/elasticbeanstalk/).

## Dockerfile

Dockerfile on [Github](https://github.com/noplanb/rails-base/blob/master/Dockerfile).

## Build
Commmit changes and create new tag.

To build base image use:

```shell
make build
```

To tag latest image:

```shell
make tag_latest
```

To push to [Docker Hub repo](https://registry.hub.docker.com/u/zazo/rails/):

```shell
make push
```

Or do this all:

```shell
make
```

## Usage

Simple `Dockerfile` for your rails app is:

```Dockerfile
FROM zazo/rails

EXPOSE 8000
```

Simple `Dockerrun.aws.json` is:

```json
{
  "AWSEBDockerrunVersion": 1,
  "Ports": [
    {
      "ContainerPort": "8000"
    }
  ],
  "Volumes": [
    {
      "HostDirectory": "/var/app/bundle",
      "ContainerDirectory": "/usr/local/bundle"
    },
    {
      "HostDirectory": "/var/app/tmp",
      "ContainerDirectory": "/usr/src/app/tmp"
    }
  ],
  "Logging": "/usr/src/app/log"
}
```
