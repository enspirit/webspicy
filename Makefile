SHELL=/bin/bash -o pipefail

# Load them from an optional .env file
-include .env

################################################################################
### Config variables
###

DOCKER_REGISTRY := $(or ${DOCKER_REGISTRY},${DOCKER_REGISTRY},hub.docker.com)
DOCKER_TAG := $(or ${DOCKER_TAG},${DOCKER_TAG},latest)

################################################################################
# Release helpers
#

bumped:
	bundle install
	cd examples/restful
	bundle install
	bundle exec rake	

release:
	bundle exec rake gem
	gem push `ls -Art pkg/*.gem | tail -n 1`

################################################################################
# Docker images generation rules
#

Dockerfile.built: Dockerfile $(shell find . -type f | grep -v "\/tmp\|\.idea\|\.bundle\|\.log\|\.bash_history\|\.pushed\|\.built\|vendor")
	docker build -t enspirit/webspicy . | tee Dockerfile.log
	touch Dockerfile.built

Dockerfile.pushed: Dockerfile.built
	docker tag wespicy $(DOCKER_REGISTRY)/enspirit/webspicy:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/enspirit/webspicy:$(DOCKER_TAG) | tee -a Dockerfile.log
	touch Dockerfile.pushed

image: Dockerfile.built

push: Dockerfile.pushed
