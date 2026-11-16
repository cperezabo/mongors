# MongoDB with replica set

Docker image based on the official MongoDB image, running a single-node replica set (`rs0`) for development and
testing, so transactions and change streams work.

## Usage

Images are published to Docker Hub as `cperezabo/mongors:<version>`, matching the official `mongo` tags from 6.0 on
(the image relies on `mongosh`). The Publish workflow builds them for amd64 and arm64: every push to `main` publishes
the latest stable MongoDB, and running it manually publishes the version you pass. It needs the `DOCKERHUB_USERNAME` and
`DOCKERHUB_TOKEN` repository secrets.

To publish from your machine instead:

```shell
./build.sh 9.0.8
```

The container's health check initiates the replica set and reports healthy once the node can take writes, so wait for
it before connecting. On a restart it finds the set already initiated; if the container comes back with a different
host name over the same data, it repoints the member to the new one.

The health check also sets `w: 1` as the default write concern before reporting healthy. MongoDB's own default,
`majority`, makes every write and every transaction commit wait for the journal to reach the disk; with `w: 1` the node
acknowledges them once applied, so a crash can lose the last acknowledged writes. Transactions work the same. A default
set by hand is kept, and a client can still ask for another write concern in its connection string (`w=majority`):

```js
db.adminCommand({ setDefaultRWConcern: 1, defaultWriteConcern: { w: 'majority' } })
```

The member is announced as `<host>:27017`, where `<host>` is the container's host name. Clients that discover the
replica set connect to that name. On a user-defined Docker network, such as the ones Docker Compose and GitHub Actions
service containers use, Docker resolves the default host name (the container's short ID), so there is nothing to
configure. Set `PRIMARY_HOST` only to announce a different name.

```yaml
services:
  db:
    image: cperezabo/mongors:9.0.8
  app:
    environment:
      MONGODB_URL: mongodb://db/test
    depends_on:
      db:
        condition: service_healthy
```

Clients outside that network, such as tools on the host connecting through a published port, cannot resolve the member
name: add `directConnection=true` to their connection string.

Scripts in `/docker-entrypoint-initdb.d` are not supported: the official entrypoint runs them before the replica set
exists, and their writes fail with `not primary`.
