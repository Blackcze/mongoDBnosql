#!/bin/bash

# MongoDB router container (mongos)
CONTAINER_NAME=router-01
DB_NAME=MyDatabase

echo "Applying collection validators via $CONTAINER_NAME..."

# Collection: Vyroba
docker exec "$CONTAINER_NAME" mongosh "$DB_NAME" --username your_admin --password your_password --authenticationDatabase admin --eval '
db.runCommand({
  collMod: "Vyroba",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["date"],
      properties: {
        date: { bsonType: "string","pattern": "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\+\\d{2}:\\d{2}$"},
        "PE [MW]": { bsonType: "number" },
        "PPE [MW]": { bsonType: "number" },
        "JE [MW]": { bsonType: "number" },
        "VE [MW]": { bsonType: "number" },
        "PVE [MW]": { bsonType: "number" },
        "AE [MW]": { bsonType: "number" },
        "ZE [MW]": { bsonType: "number" },
        "VTE [MW]": { bsonType: "number" },
        "FVE [MW]": { bsonType: "number" }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
'

# Collection: PreshranicniToky
docker exec "$CONTAINER_NAME" mongosh "$DB_NAME" --username your_admin --password your_password --authenticationDatabase admin --eval '
db.runCommand({
  collMod: "PreshranicniToky",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["date"],
      properties: {
        date: { bsonType: "string","pattern": "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\+\\d{2}:\\d{2}$"},
        "PSE Skutečnost [MW]": { bsonType: "number" },
        "PSE Plán [MW]": { bsonType: "number" },
        "SEPS Skutečnost [MW]": { bsonType: "number" },
        "SEPS Plán [MW]": { bsonType: "number" },
        "APG Skutečnost [MW]": { bsonType: "number" },
        "APG Plán [MW]": { bsonType: "number" },
        "TenneT Skutečnost [MW]": { bsonType: "number" },
        "TenneT Plán [MW]": { bsonType: "number" },
        "50HzT Skutečnost [MW]": { bsonType: "number" },
        "50HzT Plán [MW]": { bsonType: "number" },
        "CEPS Skutečnost [MW]": { bsonType: "number" },
        "CEPS Plán [MW]": { bsonType: "number" }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
'

# Collection: OdhadovanaCenaOdchylky
docker exec "$CONTAINER_NAME" mongosh "$DB_NAME" --username your_admin --password your_password --authenticationDatabase admin --eval '
db.runCommand({
  collMod: "OdhadovanaCenaOdchylky",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["date", "EstimatedPrice_CZK_MWh"],
      properties: {
        date: { bsonType: "string","pattern": "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\+\\d{2}:\\d{2}$"},
        EstimatedPrice_CZK_MWh: { bsonType: "number" }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
'

# Collection: GenerationPlan
docker exec "$CONTAINER_NAME" mongosh "$DB_NAME" --username your_admin --password your_password --authenticationDatabase admin --eval '
db.runCommand({
  collMod: "GenerationPlan",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["date", "PlannedProduction_MWh"],
      properties: {
        date: { bsonType: "string","pattern": "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\+\\d{2}:\\d{2}$"},
        PlannedProduction_MWh: { bsonType: "number" }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
'

echo "All collection validators have been successfully applied."
