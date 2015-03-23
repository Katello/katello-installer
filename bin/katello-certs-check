#!/usr/bin/env bash

function usage () {
  cat <<HELP >&2
Verifies, that custom ssl cert files are usable
as part of the Katello installation.

usage: $0 -c CERT_FILE -k KEY_FILE -r REQ_FILE -b CA_BUNDLE_FILE
HELP
}

while getopts "c:k:r:b:" opt; do
    case $opt in
        c)
            CERT_FILE="$OPTARG"
            ;;
        k)
            KEY_FILE="$OPTARG"
            ;;
        r)
            REQ_FILE="$OPTARG"
            ;;
        b)
            CA_BUNDLE_FILE="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

EXIT_CODE=0

if [ -z "$CERT_FILE" -o -z "$KEY_FILE" -o -z "$CA_BUNDLE_FILE" ]; then
    echo "One of the required parameters missing" >&2
    usage
    exit 1
fi

function error () {
    echo "[FAIL]"
    CURRENT_EXIT_CODE=$1
    EXIT_CODE=$((EXIT_CODE|CURRENT_EXIT_CODE))
    echo $2 >&2
}

function success () {
    echo "[OK]"
}

function show-details () {
    printf "Validating the certificate "
    CERT_SUBJECT=$(openssl x509 -noout -subject -in $CERT_FILE)
    echo $CERT_SUBJECT
}

function check-priv-key () {
    printf "Check private key matches the certificate: "
    CERT_MOD=$(openssl x509 -noout -modulus -in $CERT_FILE)
    KEY_MOD=$(openssl rsa -noout -modulus -in $KEY_FILE)
    if [ "$CERT_MOD" != "$KEY_MOD" ]; then
        error 2 "The $KEY_FILE does not match the $CERT_FILE"
    else
        success
    fi
}

function check-ca-bundle () {
    printf "Check ca bundle verifies the cert file: "
    CHECK=$(openssl verify -CAfile $CA_BUNDLE_FILE -purpose sslserver -verbose $CERT_FILE 2>&1)
    if [ $? == "0" ]; then
        success
    else
        error 4  "The $CA_BUNDLE_FILE does not verify the $CERT_FILE"
        echo $CHECK
    fi
}

show-details
check-priv-key
check-ca-bundle

if [ $EXIT_CODE == "0" ]; then
    cat <<EOF
Validation succeeded.

To use the certificates on the Katello main server, run:

    katello-installer --certs-server-cert "$CERT_FILE"\\
                      --certs-server-cert-req "$REQ_FILE"\\
                      --certs-server-key "$KEY_FILE"\\
                      --certs-server-ca-cert "$CA_BUNDLE_FILE"\\
                      --certs-update-server --certs-update-server-ca

To use them inside a \$CAPSULE, run this command INSTEAD:

    capsule-certs-generate --capsule-fqdn "$CAPSULE"\\
                           --certs-tar  "~/$CAPSULE-certs.tar"\\
                           --server-cert "$CERT_FILE"\\
                           --server-cert-req "$REQ_FILE"\\
                           --server-key "$KEY_FILE"\\
                           --server-ca-cert "$CA_BUNDLE_FILE"\\
                           --certs-update-server
EOF
else
    exit $EXIT_CODE
fi
