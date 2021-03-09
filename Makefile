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

Dockerfile.built: Dockerfile $(shell find . -type f | grep -v "\/tmp\|\.idea\|\.bundle\|\.log\|\.bash_history\|\.pushed\|\.built\|vendor")
	docker build -t enspirit/webspicy . | tee Dockerfile.log
	touch Dockerfile.built

Dockerfile.tester.built: Dockerfile.built
	docker build -t enspirit/webspicy:tester --file Dockerfile.tester . | tee Dockerfile.tester.log
	touch Dockerfile.tester.built

Dockerfile.mocker.built: Dockerfile.built
	docker build -t enspirit/webspicy:mocker --file Dockerfile.mocker . | tee Dockerfile.mocker.log
	touch Dockerfile.mocker.built

Dockerfile.pushed: Dockerfile.built
	docker tag enspirit/webspicy enspirit/webspicy:$(DOCKER_TAG)
	docker push enspirit/webspicy:$(DOCKER_TAG) | tee -a Dockerfile.log
	touch Dockerfile.pushed

Dockerfile.tester.pushed: Dockerfile.tester.built
	@if [ $(DOCKER_TAG) = "latest" ]; then\
		docker push enspirit/webspicy:tester | tee -a Dockerfile.tester.log;\
	else\
		docker tag enspirit/webspicy:tester enspirit/webspicy:$(DOCKER_TAG)-tester;\
		docker push enspirit/webspicy:$(DOCKER_TAG)-tester | tee -a Dockerfile.tester.log;\
	fi
	touch Dockerfile.tester.pushed

Dockerfile.mocker.pushed: Dockerfile.mocker.built
	@if [ $(DOCKER_TAG) = "latest" ]; then\
		docker push enspirit/webspicy:mocker | tee -a Dockerfile.mocker.log;\
	else\
		docker tag enspirit/webspicy:mocker enspirit/webspicy:$(DOCKER_TAG)-mocker;\
		docker push enspirit/webspicy:$(DOCKER_TAG)-mocker | tee -a Dockerfile.mocker.log;\
	fi
	touch Dockerfile.mocker.pushed

images: Dockerfile.built Dockerfile.tester.built Dockerfile.mocker.built

push-images: Dockerfile.pushed Dockerfile.tester.pushed Dockerfile.mocker.pushed
