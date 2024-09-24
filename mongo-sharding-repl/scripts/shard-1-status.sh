#!/bin/bash

# Кол-во документов в реплике
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
rs.status();
EOF

read -p "Закройте окно"