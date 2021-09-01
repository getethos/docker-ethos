TAG?=latest

nginx-build:
	docker build -t getethos/nginx-static-server:$(TAG) nginx-static-server/

nginx-push:
	docker tag getethos/nginx-static-server:$(TAG) public.ecr.aws/u7h7z7i1/getethos/nginx-static-server:$(TAG)
	docker push public.ecr.aws/u7h7z7i1/getethos/nginx-static-server:$(TAG)

gatsby-static-server-build:
	docker build -t getethos/gatsby-static-server:$(TAG) gatsby-static-server/

gatsby-static-server-push:
	docker tag getethos/gatsby-static-server:$(TAG) public.ecr.aws/u7h7z7i1/getethos/nginx-static-server:$(TAG)
	docker push public.ecr.aws/u7h7z7i1/getethos/gatsby-static-server:$(TAG)

gatsby-static-server-test:
	docker build -t getethos/gatsby-static-server:test gatsby-static-server/
	cd gatsby-static-server/test && bash test.sh