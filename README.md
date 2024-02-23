# kafka-replicator
Shameless steal of Tomás Dias Almeida's kafka replicator repo but adapted to for testing across an environment using two networks
also examples do not use schema reg initially just to keep it simple

### Take the following steps
#### Run up the environment:
`docker-compose up -d`

#### Create the source topic and configure replicator:
`./configure-replicator.sh`

#### Produce some stuff:
`docker-compose exec srcKafka kafka-console-producer --bootstrap-server srcKafka:19092 --topic topic-test`

`<send some messages, control-D to exit>`

#### Comments
You should see messages replicated on the dest side
You can look at the source Control Center via <ipaddress>:/19021
And you can look at the destination Control Center via <ipaddress>:/29021
This will confirm the copy and that everything is up and running ok

To have a look at the networks use the following command:

`docker network ls`

And to see the configuration on each use:

`docker network inspect ops_network`



