#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T config_srv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "configSrv",
       configsvr: true,
    members: [
      { _id : 0, host : "config_srv:27017" }
    ]
  }
);
EOF

sleep 10

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1:27018" }
    ]
  }
);
EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 1, host : "shard2:27019" }
    ]
  }
);
EOF

sleep 10

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF

sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments()

EOF

sleep 30

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments();

EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments();

EOF