TAG?=latest

nginx-build:
	docker build -t getethos/nginx-static-server:$(TAG) nginx-static-server/

nginx-push:
	docker tag getethos/nginx-static-server:$(TAG) public.ecr.aws/u7h7z7i1/getethos/nginx-static-server:$(TAG)
	docker push public.ecr.aws/u7h7z7i1/getethos/nginx-static-server:$(TAG)

gatsby-static-server-build:
	docker build --build-arg ENABLED_MODULES="brotli" -f gatsby-static-server/base-image/Dockerfile.alpine -t getethos/gatsby-static-server-base gatsby-static-server/base-image
	docker build -t getethos/gatsby-static-server:$(TAG) gatsby-static-server/

gatsby-static-server-push:
	docker tag getethos/gatsby-static-server:$(TAG) public.ecr.aws/u7h7z7i1/getethos/gatsby-static-server:$(TAG)
	docker push public.ecr.aws/u7h7z7i1/getethos/gatsby-static-server:$(TAG)

gatsby-static-server-test:
	docker build --build-arg ENABLED_MODULES="brotli" -f gatsby-static-server/base-image/Dockerfile.alpine -t getethos/gatsby-static-server-base gatsby-static-server/base-image
	docker build -t getethos/gatsby-static-server:test gatsby-static-server/
	cd gatsby-static-server/test && bash test.sh

maintenance-page-build:
	docker build -t getethos/maintenance-page:$(TAG) maintenance-page/

maintenance-page-push:
	docker tag getethos/maintenance-page:$(TAG) 588240676032.dkr.ecr.us-east-1.amazonaws.com/maintenance-page:$(TAG)
	docker push 588240676032.dkr.ecr.us-east-1.amazonaws.com/maintenance-page:$(TAG)
