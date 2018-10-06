# Rails Sample
https://docs.docker.com/compose/rails/#define-the-project

## Getting started
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

## How to get a shell access to the container
```
docker-compose run --rm --service-ports rails bash
# example
>> rspec
>> rails c
```
