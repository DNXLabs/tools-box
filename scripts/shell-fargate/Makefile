export GOOGLE_IDP_ID?=PLACEHOLDER
export GOOGLE_SP_ID?=PLACEHOLDER
export AZURE_TENANT_ID?=PLACEHOLDER			# Update if using azure-ad instead of google	
export AZURE_APP_ID_URI?=PLACEHOLDER		# Update if using azure-ad instead of google

export AWS_DEFAULT_REGION?=ap-southeast-2
CLUSTER=							# Update parameters for container access
TASK=								# Update parameters for container access

GOOGLE_AUTH_IMAGE=public.ecr.aws/dnxsolutions/aws-google-auth:latest
AZURE_AUTH_IMAGE=public.ecr.aws/dnxsolutions/docker-aws-azure-ad:latest
AWS_IMAGE=public.ecr.aws/dnxsolutions/aws-v2:latest

RUN_GOOGLE_AUTH  =docker run -it --rm --env-file=.env -v $(PWD)/.env.auth:/work/.env $(GOOGLE_AUTH_IMAGE)
RUN_AZURE_AUTH   =docker run -it --rm --env-file=.env -v $(PWD)/.env.auth:/work/.env $(AZURE_AUTH_IMAGE)
RUN_AWS        	 =docker run -i --rm --env-file=.env.auth --env-file=.env -v $(PWD):/work --entrypoint "" $(AWS_IMAGE)

SHELL_FARGATE_IMAGE=shell-fargate

# Check for specific environment variables
env-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

.env:
	@echo "make .env"
	cp .env.template .env
	echo >> .env
	touch .env.auth
	touch .env.assume

clean-dotenv:
	-rm .env

.env.assume: .env
	@echo "make .env.assume"
	echo > .env.assume
	$(RUN_AWS) assume-role.sh > .env.assume
.PHONY: .env.assume

google-auth: .env env-GOOGLE_IDP_ID env-GOOGLE_SP_ID
	echo > .env.auth
	$(RUN_GOOGLE_AUTH)

azure-auth: .env env-AZURE_TENANT_ID env-AZURE_APP_ID_URI
	echo > .env.auth
	$(RUN_AZURE_AUTH)

build:
	@if [ -z $(shell sh -c "docker images -q $(SHELL_FARGATE_IMAGE):latest 2> /dev/null") ]; then\
		echo Unable to find image ${SHELL_FARGATE_IMAGE} locally;\
		echo starting build...;\
		docker build -t $(SHELL_FARGATE_IMAGE) .;\
	else\
		echo Build skipped;\
		echo If you want to build a new image please run \'docker image rm ${SHELL_FARGATE_IMAGE}\';\
	fi

shell-fargate: .env build .env.assume
	@echo "shell-fargate"
	docker run -i --rm --env-file=.env.assume --env-file=.env -v $(PWD):/work --entrypoint "/bin/bash" $(SHELL_FARGATE_IMAGE) ./shell-fargate.sh $(CLUSTER) $(TASK)
.PHONY: .shell-fargate