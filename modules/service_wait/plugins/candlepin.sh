confine [ $SERVICE = 'tomcat6' -o $SERVICE = 'tomcat7' ]

TOMCAT_PORT=${TOMCAT_PORT:-8443}
TOMCAT_SERV_PORT=${TOMCAT_SERV_PORT:-8005}
TOMCAT_TEST_URL=${TOMCAT_TEST_URL:-https://localhost:$TOMCAT_PORT/candlepin/status}

service-wait () {
    wait-for-url $TOMCAT_TEST_URL
    # RHBZ 789288 - wait until data port is avaiable
    wait-for-port $TOMCAT_SERV_PORT
}
