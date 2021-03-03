TAG?=latest

nginx-build:
	docker build -t getethos/nginx-static-server:$(TAG) nginx-static-server/

nginx-push:
	docker tag getethos/nginx-static-server:$(TAG) 588240676032.dkr.ecr.us-east-1.amazonaws.com/nginx-static-server:$(TAG)
	docker push 588240676032.dkr.ecr.us-east-1.amazonaws.com/nginx-static-server:$(TAG)