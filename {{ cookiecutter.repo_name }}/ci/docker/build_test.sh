#!/bin/sh

if [ -z "$1" ]; then
    echo "Error: Missing argument. Usage: ./build_test.sh IMAGE_NAME"
    exit 1
fi

IMAGE_NAME=$1

docker build --tag ${IMAGE_NAME} .
docker run --rm -i ${IMAGE_NAME} --help
