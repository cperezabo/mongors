# MongoDB with replica set

Docker image based on official MongoDB image with a ready replica set for testing purposes.

Many, I mean, MANY improvements can be done to this, but at the moment it covers my needs

Any idea is welcome

## Usage

Build the image with the MongoDB version you need

```shell
docker build . --build-arg VERSION=4.4 --tag mongors
```

Run the image as normal, add the `?replicaSet=rs0` param to the connection url and pray 🙏! 🤣

If you are working with docker-compose, set the `PRIMARY_HOST` environment variable to match your service name as follow

```yaml
# ...
services:
  db:
    image: mongors
    env:
      PRIMARY_HOST: db
# ...
```
