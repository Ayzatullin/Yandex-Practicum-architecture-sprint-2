#!/bin/bash

# Кол-во документов в реплике
docker compose exec -T shard1-repl1 mongosh --port 27022 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

read -p "Закройте окно"