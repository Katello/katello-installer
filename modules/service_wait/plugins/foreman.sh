confine [ $SERVICE = 'foreman' ]

FOREMAN_TEST_URL=${FOREMAN_TEST_URL:-http://localhost:5500/foreman/api}

service-wait () {
    wait-for-url $FOREMAN_TEST_URL
}
