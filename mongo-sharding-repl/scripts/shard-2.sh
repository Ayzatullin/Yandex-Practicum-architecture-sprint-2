#!/bin/bash

# Кол-во документов в реплике
docker compose exec -T shard2 mongosh --port 27020 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

read -p "Закройте окно"