#!/bin/bash

# Кол-во документов в реплике
docker compose exec -T shard2-repl1 mongosh --port 27024 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

read -p "Закройте окно"