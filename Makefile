TAG?=latest

nginx-build:
	docker build -t getethos/nginx-static-server:$(TAG) nginx-static-server/

nginx-push:
	docker push getethos/nginx-static-server:$(TAG)