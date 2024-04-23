#!/bin/sh

if [ -z "$1" ]; then
    echo "Error: Missing argument. Usage: ./install_dependencies.sh PANDOC_VERSION"
    exit 1
fi

PANDOC_VERSION=$1

wget https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb
dpkg -i pandoc-${PANDOC_VERSION}-1-amd64.deb
rm pandoc-${PANDOC_VERSION}-1-amd64.deb

pip install ."[docs]"
