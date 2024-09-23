#!/bin/bash

# Подключаемся к серверу конфигурации и инициализируемся:
docker compose exec -T configSrv mongosh --port 27019 <<EOF
rs.initiate({_id : "config_server", configsvr: true, members: [{ _id : 0, host : "configSrv:27019" }]});
exit();
EOF

# Создаем реплики шарда 1:
docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate({_id: "shard1", members: [{_id: 0, host: "shard1:27018"},{_id: 1, host: "shard1-repl1:27022"},{_id: 2, host: "shard1-repl2:27023"}]})
exit();
EOF

# Создаем реплики шарда 2:
docker compose exec -T shard2 mongosh --port 27020 <<EOF
rs.initiate({_id: "shard2", members: [{_id: 0, host: "shard2:27020"},{_id: 1, host: "shard2-repl1:27024"},{_id: 2, host: "shard2-repl2:27025"}]})
exit();
EOF

# Инцициализируем роутер и еаполняем его тестовыми данными:
docker compose exec -T mongos_router mongosh --port 27017 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard1/shard1-repl1:27022");
sh.addShard( "shard1/shard1-repl2:27023");
sh.addShard( "shard2/shard2:27020");
sh.addShard( "shard2/shard2-repl1:27024");
sh.addShard( "shard2/shard2-repl2:27025");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });

use somedb;
for(var i = 0; i < 10000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
exit();
EOF



