#!/bin/bash

echo "Importing data into MongoDB..."
docker-compose exec router01 mongosh --port 27017 -u "your_admin" -p "your_password" --authenticationDatabase admin --eval "

sh.enableSharding(\"MyDatabase\");

sh.shardCollection(\"MyDatabase.Vyroba\",{ date : 'hashed' });
sh.shardCollection(\"MyDatabase.GenerationPlan\",{ date : 'hashed' });
sh.shardCollection(\"MyDatabase.PreshranicniToky\",{ date : 'hashed' });
sh.shardCollection(\"MyDatabase.OdhadovanaCenaOdchylky\",{ date : 'hashed' });

"

# Složka s JSON soubory
JSON_DIR="/home/user/mongoDB/data"

for file in "$JSON_DIR"/*.json; do
  [ -e "$file" ] || continue
  collection=$(basename "$file" .json)
  echo "Importing $file into collection: $collection"

  mongoimport --host localhost:27117 \
    --username your_admin \
    --password your_password \
    --authenticationDatabase admin \
    --db MyDatabase \
    --collection "$collection" \
    --file "$file" \
    --jsonArray \

done

echo "Data import complete."
