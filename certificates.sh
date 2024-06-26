#!/bin/bash
elasti_cert_utils() {
    docker run -ti --rm -v $(pwd)/certs:/usr/share/elasticsearch/config/certs docker.elastic.co/elasticsearch/elasticsearch:8.7.1 "$@"
}

if [ ! -f certs/ca.zip ]; then
    echo "Creating CA"
    elasti_cert_utils bin/elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip
    unzip certs/ca.zip -d certs
fi
if [ ! -f certs/certs.zip ]; then
    echo "Creating certs"
    if [ ! -f certs/instances.yml ]; then
        echo "we need to have instances.yml files to creates certs !!"
        exit 1
    fi
    elasti_cert_utils bin/elasticsearch-certutil cert --silent --pem -out config/certs/certs.zip --in config/certs/instances.yml --ca-cert config/certs/ca/ca.crt --ca-key config/certs/ca/ca.key
    unzip certs/certs.zip -d certs
fi
