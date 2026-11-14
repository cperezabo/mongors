#!/usr/bin/env bash

# Docker runs this check from the moment the container starts, so it doubles as the replica set initializer: it
# initiates the set the first time, repoints the only member when the container comes back with another host name
# over the same data, and reports healthy only once this node can take writes.

member="${PRIMARY_HOST:-$(hostname)}:27017"

exec mongosh --quiet --norc --eval "
  const member = { _id: 0, host: '$member' };
  try {
    rs.status();
  } catch (error) {
    if (error.codeName === 'NotYetInitialized') {
      rs.initiate({ _id: 'rs0', members: [member] });
    } else if (error.codeName === 'InvalidReplicaSetConfig') {
      rs.reconfig({ ...rs.conf(), members: [member] }, { force: true });
    } else {
      throw error;
    }
  }
  quit(db.hello().isWritablePrimary ? 0 : 1);
"
