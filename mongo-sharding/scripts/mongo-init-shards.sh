#!/bin/bash

### Инициализация шардов

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate({_id:"shard1", members:[{ _id:0, host:"shard1:27018"}] });
exit();
EOF

docker compose exec -T shard2 mongosh --port 27018 --quiet <<EOF
rs.initiate({_id:"shard2", members:[{ _id:0, host:"shard2:27018"}] })
exit();
EOF
