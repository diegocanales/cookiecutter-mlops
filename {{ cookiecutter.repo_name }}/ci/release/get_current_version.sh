#!/bin/bash

## Usage
# bash ./ci/release/get_current_version.sh path/to/version_file.py

FILE=$1

if [ ! -f "$FILE" ]
then
  echo "$FILE not found"
  exit 1
fi

version=$(grep -oP '(?<=__version__ = ")[^"]*' $FILE)
echo "${version}"
