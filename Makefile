SHELL=/bin/bash -o pipefail

# Load them from an optional .env file
-include .env

################################################################################
### Config variables
###

DOCKER_TAG := $(or ${DOCKER_TAG},${DOCKER_TAG},latest)

################################################################################
# Release helpers
#

bundle-update:
	bundle update
	cd examples/restful && bundle update

bundle-install:
	bundle install
	cd examples/restful && bundle install
bundle: bundle-install

release:
	bundle exec rake
	bundle exec rake gem
	gem push `ls -Art pkg/*.gem | tail -n 1`

################################################################################
# Docker images generation rules
#

Dockerfile.built: Dockerfile $(shell find . -type f | grep -v "\/tmp\|\.idea\|\.bundle\|\.log\|\.bash_history\|\.pushed\|\.built\|vendor")
	docker build -t enspirit/webspicy . | tee Dockerfile.log
	touch Dockerfile.built

Dockerfile.pushed: Dockerfile.built
	docker tag enspirit/webspicy enspirit/webspicy:$(DOCKER_TAG)
	docker push enspirit/webspicy:$(DOCKER_TAG) | tee -a Dockerfile.log
	touch Dockerfile.pushed

image: Dockerfile.built

push-image: Dockerfile.pushed
