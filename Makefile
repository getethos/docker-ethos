TAG?=latest

nginx-build:
	docker build -t getethos/nginx-static-server:$(TAG) nginx-static-server/