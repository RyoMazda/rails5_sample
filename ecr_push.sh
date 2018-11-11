#!/bin/bash

PROFILE=lecsum
REGION=ap-northeast-1
RAILS_APP_IMAGE_URL=431120073761.dkr.ecr.ap-northeast-1.amazonaws.com/rails5-sample/rails-app

# ecr login
aws ecr describe-repositories --profile ${PROFILE} --region ${REGION}
aws ecr get-login --no-include-email --profile ${PROFILE} --region ${REGION} | sh

# push rails app container
docker build -t ${RAILS_APP_IMAGE_URL} -f docker/rails/Dockerfile .
docker push ${RAILS_APP_IMAGE_URL}
aws ecr describe-repositories --profile ${PROFILE} --region ${REGION}

# push nginx container
