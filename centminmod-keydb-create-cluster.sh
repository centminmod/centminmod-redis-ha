#!/bin/bash
######################################################################
# https://docs.keydb.dev/docs/cluster-tutorial/#creating-a-keydb-cluster-using-the-create-cluster-script
# modified for Centmin Mod keydb configuration
######################################################################
# Settings
BIN_PATH="/usr/local/bin"
CLUSTER_HOST=127.0.0.1
PORT=30000
TIMEOUT=2000
NODES=6
REPLICAS=1
PROTECTED_MODE=yes
ADDITIONAL_OPTIONS=""

# default keydb server settings
SERVER_THREADS=2
APPEND_ONLY='yes'
######################################################################
CLUSTER_DIR='/etc/keydb/cluster'
CLUSTER_DATADIR='/var/lib/keydb-cluster'
CLUSTER_LOGDIR='/var/log/keydb-cluster'
######################################################################
# You may want to put the above config parameters into config.sh in order to
# override the defaults without modifying this script.

if [ ! -d "$CLUSTER_DIR" ]; then
    mkdir -p "$CLUSTER_DIR"
    chown -R keydb:keydb "$CLUSTER_DIR"
fi
if [ ! -d "$CLUSTER_DATADIR" ]; then
    mkdir -p "$CLUSTER_DATADIR"
    chown -R keydb:keydb "$CLUSTER_DATADIR"
fi
if [ ! -d "$CLUSTER_LOGDIR" ]; then
    mkdir -p "$CLUSTER_LOGDIR"
    chown -R keydb:keydb "$CLUSTER_LOGDIR"
fi

if [ -a config.sh ]
then
    source "config.sh"
fi

# Computed vars
ENDPORT=$((PORT+NODES))

if [ "$1" == "start" ]
then
    while [ $((PORT < ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        echo "Starting $PORT"
        if [ "$2" == "flash" ]
        then
            ADDITIONAL_OPTIONS="--save \"\" \"\" \"\" --semi-ordered-set-bucket-size 8 --client-output-buffer-limit replica 1 1 0 --maxmemory 100000000 --storage-provider flash ./$PORT.flash"
        fi
        $BIN_PATH/keydb-server --dir ${CLUSTER_DATADIR} --server-threads $SERVER_THREADS --port $PORT  --protected-mode $PROTECTED_MODE --cluster-enabled yes --cluster-config-file "${CLUSTER_DIR}/nodes-${PORT}.conf" --cluster-node-timeout $TIMEOUT --appendonly $APPEND_ONLY --appendfilename appendonly-${PORT}.aof --dbfilename dump-${PORT}.rdb --logfile "${CLUSTER_LOGDIR}/${PORT}.log" --daemonize yes ${ADDITIONAL_OPTIONS}
    done
    exit 0
fi

if [ "$1" == "create" ]
then
    HOSTS=""
    while [ $((PORT < ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        HOSTS="$HOSTS $CLUSTER_HOST:$PORT"
    done
    OPT_ARG=""
    if [ "$2" == "-f" ]; then
        OPT_ARG="--cluster-yes"
    fi
    $BIN_PATH/keydb-cli --cluster create $HOSTS --cluster-replicas $REPLICAS $OPT_ARG
    exit 0
fi

if [ "$1" == "stop" ]
then
    while [ $((PORT < ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        echo "Stopping $PORT"
        $BIN_PATH/keydb-cli -p $PORT shutdown nosave
    done
    exit 0
fi

if [ "$1" == "watch" ]
then
    PORT=$((PORT+1))
    while [ 1 ]; do
        clear
        date
        $BIN_PATH/keydb-cli -p $PORT cluster nodes | head -30
        sleep 1
    done
    exit 0
fi

if [ "$1" == "tail" ]
then
    INSTANCE=$2
    PORT=$((PORT+INSTANCE))
    tail -f "${CLUSTER_LOGDIR}/${PORT}.log"
    exit 0
fi

if [ "$1" == "tailall" ]
then
    tail -f ${CLUSTER_LOGDIR}/*.log
    exit 0
fi

if [ "$1" == "call" ]
then
    while [ $((PORT < ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        $BIN_PATH/keydb-cli -p $PORT $2 $3 $4 $5 $6 $7 $8 $9
    done
    exit 0
fi

if [ "$1" == "clean" ]
then
    rm -rf ${CLUSTER_LOGDIR}/*.log
    rm -rf ${CLUSTER_DATADIR}/appendonly*.aof
    rm -rf ${CLUSTER_DATADIR}/dump*.rdb
    rm -rf ${CLUSTER_DIR}/nodes*.conf
    rm -rf ${CLUSTER_DATADIR}/*.flash
    rm -rf ${CLUSTER_DATADIR}/temp*.rdb
    exit 0
fi

if [ "$1" == "clean-logs" ]
then
    rm -rf *.log
    exit 0
fi
echo
echo "Usage: $0 [start|create|stop|watch|tail|clean|call]"
echo
echo "start       -- Launch Redis Cluster instances."
echo "create [-f] -- Create a cluster using keydb-cli --cluster create."
echo "stop        -- Stop Redis Cluster instances."
echo "watch       -- Show CLUSTER NODES output (first 30 lines) of first node."
echo "tail <id>   -- Run tail -f of instance at base port + ID."
echo "tailall     -- Run tail -f for all the log files at once."
echo "clean       -- Remove all instances data, logs, configs."
echo "clean-logs  -- Remove just instances logs."
echo "call <cmd>  -- Call a command (up to 7 arguments) on all nodes."