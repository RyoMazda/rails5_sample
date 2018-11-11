# Rails Sample


## Philosophy
* keep everything under control as much as possible (e.g. No Capistrano, No Beanstalk)
* make the difference between local and deployment minimal
* control the difference with environment variables


## Brief System Architecture
* Web server: nginx (reverse proxy to the app server)
* App server: rails puma (main application)
* DB: postgresql


## How to use
### Getting started
```
git clone this
cd rails5_sample
docker-compose up -d --build
# Access to localhost:3000
# That's all. You can now start the rails app development!
```

When you call it a day, don't forget
```
docker-compose down
```

### How to get a shell access to the container
```
docker-compose run --rm --service-ports rails bash
# example
>> rspec
>> rails c
```

### How to run the servers in production-mock-mode
```
docker-compose up -f docker-compose-production.yml -d --build
# Access to localhost:80
```

#### Differences
* `localhost:3000` by `docker-compose.yml` above is App server by rails puma
* In production mode, nginx is running as reverse proxy server and listening on port 80
* It serves static files `/rails/public/assets/*` and send other requests to the App server
* See `docker/nginx/my_app.conf` for more detail

#### References
* https://qiita.com/na-o-ys/items/1a863419e1f6c3063ace
* https://qiita.com/na-o-ys/items/d96829e27a294903c42d


## Deploy
* AWS & Terraform

### How to develop
* install terraform on your local machine
* prepare S3 bucket for terraform backend
* put terraform.tfvars in terraform dir for secret variables
* tentatively terraform commands are executed locally
* do not forget `./ecr_push.sh` to update images
(before you do this `terraform apply` for ECS task and service due to lack of ECR image)

### ssh into the ECS instance for debugging
* get private key from admin
* check the global ip address of the instance
```
ssh -i [path to the private key] ec2-user@ec2-[public ip].ap-northeast-1.compute.amazonaws.com
```
