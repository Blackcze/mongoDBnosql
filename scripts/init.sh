#!/bin/bash

echo "Waiting for the launch of MongoDB services..."

sudo chown -R user:user /home/user/mongoDB
sudo chown -R user:user .

sleep 15

chmod +x scripts/dataimport.sh
chmod +x scripts/set_validators.sh
chmod +x scripts/init-configserver.js
chmod +x scripts/init-shard01.js
chmod +x scripts/init-shard02.js
chmod +x scripts/init-shard03.js
chmod +x scripts/init-router.js
chmod +x scripts/auth.js

curl -fsSL https://downloads.mongodb.com/compass/mongosh-1.8.0-linux-x64.tgz -o mongosh.tgz
tar -xvzf mongosh.tgz
mv mongosh-1.8.0-linux-x64/bin/mongosh /usr/local/bin/mongosh

sleep 30

echo "Initializing MongoDB cluster components..."

docker-compose exec configsvr01 bash "/scripts/init-configserver.js"
sleep 15
docker-compose exec shard01-a bash "/scripts/init-shard01.js"
docker-compose exec shard02-a bash "/scripts/init-shard02.js"
docker-compose exec shard03-a bash "/scripts/init-shard03.js"

sleep 20

docker-compose exec router01 sh -c "mongosh < /scripts/init-router.js"

docker-compose exec configsvr01 bash "/scripts/auth.js"
docker-compose exec shard01-a bash "/scripts/auth.js"
docker-compose exec shard02-a bash "/scripts/auth.js"
docker-compose exec shard03-a bash "/scripts/auth.js"

sleep 15
echo "Running data import script..."
scripts/dataimport.sh