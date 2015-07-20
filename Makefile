NAME=zazo/rails
VERSION=`git describe --tags`
CORE_VERSION=HEAD

all: version build tag_latest

version:
	git describe --tags

build:
	docker build -t $(NAME):$(VERSION) --rm .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME)
