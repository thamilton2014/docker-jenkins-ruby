#!/bin/bash --login

MASTER=http://192.168.99.100:8080
EXECUTORS=3
NAME=slave_$(date "+%Y.%m.%d-%H.%M.%S")
LABELS=automation_node

function shutdown {
    echo "Shutting down Jenkins slave..."
    kill -s SIGTERM $SLAVE_PID
    wait $SLAVE_PID
    echo "Shutdown complete"
}

java ${JAVA_OPTS} -jar swarm-client-2.0-jar-with-dependencies.jar \
	-master $MASTER \
	-executors $EXECUTORS \
	-name $NAME \
	-labels $LABELS \
	-username $USERNAME \
	-password $PASSWORD \
	-fsroot /opt/builds &
SLAVE_PID=$!

trap shutdown SIGTERM SIGINT
wait $SLAVE_PID