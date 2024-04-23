#!/bin/sh

if [ "$#" -ne 5 ]; then
    echo "Error: Missing arguments. Usage: ./build_and_push.sh PACKAGE_NAME ARTIFACT_REGISTRY_URL PROJECT_ID REGISTRY_ID IMAGE_NAME"
    exit 1
fi

PACKAGE_NAME=$1
ARTIFACT_REGISTRY_URL=$2
PROJECT_ID=$3
REGISTRY_ID=$4
IMAGE_NAME=$5

TAG_VERSION=$(sed -n -e 's/^__version__ = "\(.*\)"$/\1/p' ${PACKAGE_NAME}/__init__.py)
result=$(docker manifest inspect ${ARTIFACT_REGISTRY_URL}/${PROJECT_ID}/${REGISTRY_ID}/${IMAGE_NAME}:${TAG_VERSION} > /dev/null; echo $?)
if [ "$result" -eq 1 ]; then
    docker build --cache-from ${ARTIFACT_REGISTRY_URL}/${PROJECT_ID}/${REGISTRY_ID}/${IMAGE_NAME}:latest -t ${ARTIFACT_REGISTRY_URL}/${PROJECT_ID}/${REGISTRY_ID}/${IMAGE_NAME}:${TAG_VERSION} .
    docker tag ${ARTIFACT_REGISTRY_URL}/${PROJECT_ID}/${REGISTRY_ID}/${IMAGE_NAME}:${TAG_VERSION} ${ARTIFACT_REGISTRY_URL}/${PROJECT_ID}/${REGISTRY_ID}/${IMAGE_NAME}:latest
    docker push ${ARTIFACT_REGISTRY_URL}/${PROJECT_ID}/${REGISTRY_ID}/${IMAGE_NAME}:${TAG_VERSION}
    docker push ${ARTIFACT_REGISTRY_URL}/${PROJECT_ID}/${REGISTRY_ID}/${IMAGE_NAME}:latest
else
    echo "Docker version image already exists"
fi
