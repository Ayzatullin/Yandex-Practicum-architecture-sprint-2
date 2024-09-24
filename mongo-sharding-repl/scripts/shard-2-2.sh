#!/bin/bash

# Кол-во документов в реплике
docker compose exec -T shard2-repl2 mongosh --port 27025 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

read -p "Закройте окно"