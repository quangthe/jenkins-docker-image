.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

IMAGE := pcloud/jenkins-casc
TAG := latest

CONTAINER := jenkins

build: ## Build JasC image
	docker build -t ${IMAGE}:latest .

tag: ## Tag image with TAG=<value>
	docker tag ${IMAGE}:latest ${IMAGE}:${TAG}

push: ## Push image with TAG=latest
	docker push ${IMAGE}:${TAG}
