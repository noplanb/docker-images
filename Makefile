NAME=zazo/rails
# VERSION=`git describe --tags`
VERSION=1.4
CORE_VERSION=HEAD

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME)
