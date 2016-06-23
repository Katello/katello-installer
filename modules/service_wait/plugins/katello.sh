confine [ $SERVICE = 'katello' ]

KATELLO_TEST_URL=${KATELLO_TEST_URL:-http://localhost:5000/katello/api}

service-wait () {
    wait-for-url $KATELLO_TEST_URL
}
