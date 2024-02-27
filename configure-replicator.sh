# Create the test-topic
docker-compose exec srcKafka kafka-topics --bootstrap-server srcKafka:19092 --topic topic-test --create --partitions 1 --replication-factor 1


HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "testReplicator",
  "config": {
    "name": "testReplicator",
    "connector.class": "io.confluent.connect.replicator.ReplicatorSourceConnector",
    "tasks.max": "1",
    "confluent.topic.replication.factor": "1",
    "producer.override.enable.idempotence": "true",
    "producer.override.acks": "all",
    "producer.override.max.in.flight.requests.per.connection": "1",

    "topic.whitelist": "topic-test",

    "src.kafka.bootstrap.servers": "srcKafka.kafka_network:19092",
    "src.key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "src.key.converter.schemas.enable": "false",
    "src.value.converter": "org.apache.kafka.connect.storage.StringConverter",
    "src.value.converter.schema.registry.url": "http://srcSchemaregistry:8085",

    "dest.kafka.bootstrap.servers": "destKafka.kafka_network:29092",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "key.converter.schemas.enable": "false",
    "value.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter.schema.registry.url": "http://destSchemaregistry:8086"
  }
}
EOF
)


RETCODE=1
while [ $RETCODE -ne 0 ]
do
  curl -f -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors
  RETCODE=$?
  if [ $RETCODE -ne 0 ]
  then
    echo "Failed to submit replicator to Connect. This could be because the Connect worker is not yet started. Will retry in 10 seconds"
  fi
  #backoff
  sleep 10
done
echo "replicator configured"

