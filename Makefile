SHELL=/bin/bash -o pipefail

# Load them from an optional .env file
-include .env

################################################################################
### Config variables
###

# Specify which docker tag is to be used
VERSION := $(or ${VERSION},${VERSION},latest)
DOCKER_REGISTRY := $(or ${DOCKER_REGISTRY},${DOCKER_REGISTRY},docker.io)

TINY = ${VERSION}
MINOR = $(shell echo '${TINY}' | cut -f'1-2' -d'.')
# not used until 1.0
# MAJOR = $(shell echo '${MINOR}' | cut -f'1-2' -d'.')

################################################################################
# Release helpers
#
clean:
	rm -rf Dockerfile.*.log Dockerfile.*.built Dockerfile.*.pushed

bundle-update:
	bundle update
	cd examples/restful && bundle update
	cd examples/failures && bundle update

bundle-install:
	bundle install
	cd examples/restful && bundle install
	cd examples/failures && bundle install
bundle: bundle-install

install:
	rm -rf pkg
	bundle exec rake gem
	gem install pkg/*.gem

test: bundle
	bundle exec rake

release:
	bundle exec rake
	bundle exec rake gem
	gem push `ls -Art pkg/*.gem | tail -n 1`

################################################################################
# Docker images generation rules
#

# commandline

Dockerfile.built: Dockerfile $(shell find . -type f | grep -v "\/tmp\|\.idea\|\.bundle\|\.log\|\.bash_history\|\.pushed\|\.built\|vendor")
	docker build -t enspirit/webspicy . | tee Dockerfile.log
	touch Dockerfile.built

Dockerfile.pushed: Dockerfile.built
	docker tag enspirit/webspicy $(DOCKER_REGISTRY)/enspirit/webspicy:$(TINY)
	docker push $(DOCKER_REGISTRY)/enspirit/webspicy:$(TINY) | tee -a Dockerfile.log
	docker tag enspirit/webspicy $(DOCKER_REGISTRY)/enspirit/webspicy:$(MINOR)
	docker push $(DOCKER_REGISTRY)/enspirit/webspicy:$(MINOR) | tee -a Dockerfile.log
	touch Dockerfile.pushed

# tester

Dockerfile.tester.built: Dockerfile.built
	docker build -t enspirit/webspicy:tester --file Dockerfile.tester . | tee Dockerfile.tester.log
	touch Dockerfile.tester.built

Dockerfile.tester.pushed: Dockerfile.tester.built
	docker tag enspirit/webspicy:tester $(DOCKER_REGISTRY)/enspirit/webspicy:$(TINY)-tester;\
	docker push $(DOCKER_REGISTRY)/enspirit/webspicy:$(TINY)-tester | tee -a Dockerfile.tester.log;\
	docker tag enspirit/webspicy:tester $(DOCKER_REGISTRY)/enspirit/webspicy:$(MINOR)-tester;\
	docker push $(DOCKER_REGISTRY)/enspirit/webspicy:$(MINOR)-tester | tee -a Dockerfile.tester.log;\
	touch Dockerfile.tester.pushed

# mocker

Dockerfile.mocker.built: Dockerfile.built
	docker build -t enspirit/webspicy:mocker --file Dockerfile.mocker . | tee Dockerfile.mocker.log
	touch Dockerfile.mocker.built

Dockerfile.mocker.pushed: Dockerfile.mocker.built
	docker tag enspirit/webspicy:mocker $(DOCKER_REGISTRY)/enspirit/webspicy:$(TINY)-mocker;\
	docker push $(DOCKER_REGISTRY)/enspirit/webspicy:$(TINY)-mocker | tee -a Dockerfile.mocker.log;\
	docker tag enspirit/webspicy:mocker $(DOCKER_REGISTRY)/enspirit/webspicy:$(MINOR)-mocker;\
	docker push $(DOCKER_REGISTRY)/enspirit/webspicy:$(MINOR)-mocker | tee -a Dockerfile.mocker.log;\
	touch Dockerfile.mocker.pushed


images: Dockerfile.built Dockerfile.tester.built Dockerfile.mocker.built

push-images: Dockerfile.pushed Dockerfile.tester.pushed Dockerfile.mocker.pushed
