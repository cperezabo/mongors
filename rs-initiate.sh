#!/usr/bin/env bash

until mongo --eval "rs.initiate()";
do
    sleep 0.01;
done

mongo --eval "rs.reconfig({
    _id : \"rs0\",
    members: [
        { _id: 0, host: \"${PRIMARY_HOST:=localhost}\" }
    ],
}, {force: true})";
