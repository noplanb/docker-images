NAME=zazo/rails
# VERSION=`git describe --tags`
VERSION=2.0
CORE_VERSION=HEAD

all: build tag_latest

build:
	docker build -t $(NAME):$(VERSION) --rm .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME)
