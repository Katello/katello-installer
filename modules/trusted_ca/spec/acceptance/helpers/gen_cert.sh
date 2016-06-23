#!/bin/sh

OUTDIR=/etc/ssl-secure

echodo()
{
    echo "${@}"
    (${@})
}

C=US
ST=Colorado
L=Denver
O=Example
OU=Test
CN=`hostname`

csr="${OUTDIR}/test.csr"
key="${OUTDIR}/test.key"
cert="${OUTDIR}/test.crt"

mkdir $OUTDIR

# Create the certificate signing request
openssl req -new -passin pass:password -passout pass:password -out ${csr} <<EOF
${C}
${ST}
${L}
${O}
${OU}
${CN}
$USER@${CN}
.
.
EOF

[ -f ${csr} ] && echodo openssl req -text -noout -in ${csr}

# Create the Key
openssl rsa -in privkey.pem -passin pass:password -passout pass:password -out ${key}

# Create the Certificate
openssl x509 -in ${csr} -out ${cert} -req -signkey ${key} -days 1000
