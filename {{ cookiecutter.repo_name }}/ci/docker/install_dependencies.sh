#!/bin/sh
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Missing arguments. Usage: ./install_dependencies.sh ARTIFACT_REGISTRY_URL GCP_SA_KEY"
    exit 1
fi

ARTIFACT_REGISTRY_URL=$1
GCP_SA_KEY=$2

apk add --update make ca-certificates openssl python3
update-ca-certificates
base64 -d $GCP_SA_KEY > ${HOME}/gcloud-service-key.json
wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz
tar zxvf google-cloud-sdk.tar.gz && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true
google-cloud-sdk/bin/gcloud --quiet components update
google-cloud-sdk/bin/gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
docker login -u _json_key --password-stdin https://${ARTIFACT_REGISTRY_URL} < ${HOME}/gcloud-service-key.json
