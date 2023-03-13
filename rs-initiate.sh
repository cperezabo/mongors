#!/usr/bin/env bash

until mongosh --eval "rs.initiate()";
do
    sleep 0.01;
done

mongosh --eval "rs.reconfig({
    _id : \"rs0\",
    members: [
        { _id: 0, host: \"${PRIMARY_HOST:=localhost}\" }
    ],
}, {force: true})";
