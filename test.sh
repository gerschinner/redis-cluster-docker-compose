MASTER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redisclusterdockercompose_master_1)
SLAVE_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redisclusterdockercompose_slave_1)
SENTINEL_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redisclusterdockercompose_sentinel_1)

echo Redis master: $MASTER_IP
echo Redis Slave: $SLAVE_IP
echo ------------------------------------------------
echo Initial status of sentinel
echo ------------------------------------------------
docker exec redisclusterdockercompose_sentinel_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redisclusterdockercompose_sentinel_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
echo ------------------------------------------------

echo Stop redis master
docker pause redisclusterdockercompose_master_1
echo Wait for 10 seconds
sleep 10
echo Current infomation of sentinel
docker exec redisclusterdockercompose_sentinel_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redisclusterdockercompose_sentinel_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster


echo ------------------------------------------------
echo Restart Redis master
docker unpause redisclusterdockercompose_master_1
sleep 5
echo Current infomation of sentinel
docker exec redisclusterdockercompose_sentinel_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redisclusterdockercompose_sentinel_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
