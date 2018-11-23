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
docker-compose -f docker-compose-production.yml up -d --build
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
* https://thecode.pub/easy-deploy-your-docker-applications-to-aws-using-ecs-and-fargate-a988a1cc842f
* https://gist.github.com/tompave/8590031
* https://itnext.io/docker-rails-puma-nginx-postgres-999cd8866b18
  - `my_app.conf` is based on this


## Deploy
* AWS & Terraform

### How to develop
* install terraform on your local machine
* prepare S3 bucket for terraform backend
* put terraform.tfvars in terraform dir for secret variables
* tentatively terraform commands are executed locally (inside `terraform` directory)
* do not forget `export ENV=stg; ./ecr_push.sh` to update images
(before you do this `terraform apply` for ECS task and service due to lack of ECR image)

### ssh into the ECS instance for debugging
* get private key from admin
* check the global ip address of the instance
```
ssh -i [path to the private key] ec2-user@ec2-[public ip].ap-northeast-1.compute.amazonaws.com
```

## switch deploy environment
use `terraform workspace`

### `terraform workspace` commands
```
$ terraform workspace -h
Usage: terraform workspace

  Create, change and delete Terraform workspaces.

Subcommands:
    delete    Delete a workspace
    list      List Workspaces
    new       Create a new workspace
    select    Select a workspace
    show      Show the name of the current workspace
```

### References
* official document
  - https://www.terraform.io/docs/state/workspaces.html
* might be best-practice using `locals`
  - https://medium.com/@diogok/terraform-workspaces-and-locals-for-environment-separation-a5b88dd516f5
