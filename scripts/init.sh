#!/bin/bash

echo "Waiting for the launch of MongoDB services..."

/scripts/wait-for-it.sh configsvr01:27017 -- echo "configsvr01 is ready"
/scripts/wait-for-it.sh shard01-a:27017 -- echo "shard01-a is ready"
/scripts/wait-for-it.sh shard02-a:27017 -- echo "shard02-a is ready"
/scripts/wait-for-it.sh shard03-a:27017 -- echo "shard03-a is ready"
/scripts/wait-for-it.sh router01:27017 -- echo "router01 is ready"

echo "Initializing MongoDB cluster components..."

mongosh mongodb://configsvr01:27017 /scripts/init-configserver.js
mongosh mongodb://shard01-a:27017 /scripts/init-shard01.js
mongosh mongodb://shard02-a:27017 /scripts/init-shard02.js
mongosh mongodb://shard03-a:27017 /scripts/init-shard03.js
mongosh mongodb://router01:27017 /scripts/init-router.js

echo "Setting up authentication..."

mongosh mongodb://configsvr01:27017 /scripts/auth.js
mongosh mongodb://shard01-a:27017 /scripts/auth.js
mongosh mongodb://shard02-a:27017 /scripts/auth.js
mongosh mongodb://shard03-a:27017 /scripts/auth.js

echo "Done."
