export GOOGLE_IDP_ID=
export GOOGLE_SP_ID=

ASSUME_REQUIRED?=.env.assume

export SSM_PATH?=<YOUR_SSM_PATH_HERE>

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

.env.auth: .env env-GOOGLE_IDP_ID env-GOOGLE_SP_ID
	@echo "make .env.auth"
	echo > .env.auth
	docker-compose -f docker-compose.yml run --rm google-auth

.env.assume: .env env-AWS_ACCOUNT_ID env-AWS_ROLE
	@echo "make .env.assume"
	echo > .env.assume
	docker-compose -f docker-compose.yml pull aws
	docker-compose -f docker-compose.yml run --rm aws assume-role.sh > .env.assume

replace-ssm-variables: $(ASSUME_REQUIRED) env-AWS_ENV
	docker-compose -f docker-compose.yml \
		run --rm aws \
			"./ssm-fetch.sh $(SSM_PATH)"

shell-aws: $(ASSUME_REQUIRED)
	docker-compose -f docker-compose.yml \
		run --rm aws "/bin/bash"