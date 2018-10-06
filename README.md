# Rails Sample
https://docs.docker.com/compose/rails/#define-the-project

## Getting started
```
git clone this
cd rails5_sample
docker-compose up -d --build
# Access to localhost:3000
# That's all.
# When you call it a day, don't forget
docker-compose down
```

## When you want to ssh into the container
```
docker-compose run --rm --service-ports rails bash
```
