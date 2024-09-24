#!/bin/bash

# Кол-во документов в реплике
docker compose exec -T shard1-repl2 mongosh --port 27023 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

read -p "Закройте окно"