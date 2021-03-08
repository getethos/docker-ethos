TAG?=latest

nginx-build:
	docker build -t getethos/nginx-static-server:$(TAG) nginx-static-server/

nginx-push:
	docker tag getethos/nginx-static-server:$(TAG) public.ecr.aws/u7h7z7i1/getethos/nginx-static-server:$(TAG)
	docker push public.ecr.aws/u7h7z7i1/getethos/nginx-static-server:$(TAG)