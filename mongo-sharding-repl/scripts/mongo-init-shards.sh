#!/bin/bash

### Инициализация шардов

docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
rs.initiate({_id:"shard1", members:[
  { _id:0, host:"shard1-1:27018"},
  { _id:1, host:"shard1-2:27018"},
  { _id:2, host:"shard1-3:27018"}
] });
exit();
EOF

docker compose exec -T shard2-2 mongosh --port 27018 --quiet <<EOF
rs.initiate({_id:"shard2", members:[
  { _id:0, host:"shard2-1:27018"},
  { _id:1, host:"shard2-2:27018"},
  { _id:2, host:"shard2-3:27018"}
] })
exit();
EOF
