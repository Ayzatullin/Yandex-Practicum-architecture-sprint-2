#!/bin/bash

# Кол-во документов в реплике
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

read -p "Закройте окно"