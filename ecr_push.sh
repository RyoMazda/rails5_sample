#!/bin/bash

PROFILE=ams
REGION=ap-northeast-1
RAILS_APP_IMAGE_URL=954449922995.dkr.ecr.ap-northeast-1.amazonaws.com/rails5-sample-${ENV}/rails-app
NGINX_IMAGE_URL=954449922995.dkr.ecr.ap-northeast-1.amazonaws.com/rails5-sample-${ENV}/nginx

# ecr login
aws ecr describe-repositories --profile ${PROFILE} --region ${REGION}
aws ecr get-login --no-include-email --profile ${PROFILE} --region ${REGION} | sh

# push rails app container
docker build -t ${RAILS_APP_IMAGE_URL} -f docker/rails/Dockerfile .
docker push ${RAILS_APP_IMAGE_URL}

# push nginx container
docker build -t ${NGINX_IMAGE_URL} -f docker/nginx/Dockerfile .
docker push ${NGINX_IMAGE_URL}

# check again
aws ecr describe-repositories --profile ${PROFILE} --region ${REGION}
