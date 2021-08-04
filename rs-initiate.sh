#!/usr/bin/env bash

until mongo --eval 'rs.initiate()' > /dev/null;
do
    sleep 0.01;
done