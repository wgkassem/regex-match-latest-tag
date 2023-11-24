SHELL := /bin/bash
IMAGE = regex-search-tags
TAG ?= $(shell git rev-parse --short HEAD)
DRY_RUN ?= false

.PHONY: build
build:
	docker build -t ${IMAGE}:${TAG} .

.PHONY: run
run:
	docker run -e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-e GITHUB_ACTOR=ops \
		-e GITBOT_EMAIL=dummy@dmm.com \
		-e DRY_RUN=${DRY_RUN} \
		${IMAGE}:${TAG}

.PHONY: test
test:
	perl test/test_search.pl
