confine [ $SERVICE = 'postgresql' ]

# RHBZ 800534 for RHEL 6.x - pg sysvinit script return non-zero when PID is not created in 2 seconds
ignore-retval

POSTGRES_PORT=${POSTGRES_PORT:-5432}
POSTGRES_DATA=${POSTGRES_DATA:-/var/lib/pgsql/data}

service-wait () {
    wait-for-port $POSTGRES_PORT
    if [ $RETVAL -eq 0 ]; then
        # create lock and pid files if they does not exist
        [ -f "/var/lock/subsys/postgresql" ] || touch "/var/lock/subsys/postgresql"
        [ -f "/var/run/postmaster.${POSTGRES_PORT}.pid" ] || head -n 1 "$POSTGRES_DATA/postmaster.pid" > "/var/run/postmaster.${POSTGRES_PORT}.pid"
    fi
}
