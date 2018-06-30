# Rails Sample

## Getting started
```
git clone this
cd rails5_sample
docker-compose up -d
# Access to localhost:3000
# That's all.
# When you call it a day, don't forget
docker-compose down
```

## After you change Gemfile
You need to rebuild the docker image by
```
docker-compose build
```

## When you want to ssh into the container
```
docker-compose run rails bash
```
