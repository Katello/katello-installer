confine [ $SERVICE = 'qpidd' ]

QPID_PORT=${QPID_PORT:-5671}

service-wait () {
    wait-for-port $QPID_PORT
}
