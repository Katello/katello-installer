confine [ $SERVICE = 'mongodb' ]

# RHBZ 824405 - wait until service is avaiable
service-wait () {
    # we wait for a bit longer here since the journal preallocation can take quite a while
    SLEEP=2 WAIT_MAX=200 wait-for-command mongo --eval "printjson(db.getCollectionNames())"
}
