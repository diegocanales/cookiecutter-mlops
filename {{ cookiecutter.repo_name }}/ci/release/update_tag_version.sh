#!/bin/bash

## Usage
# sh ci/release/update_tag_version.sh path/to/version_file.py (major|minor|micro)

FILE=$1
TYPE=$2

if [ ! -f "$FILE" ]
then
  echo "$FILE not found"
  exit 1
fi

echo "Updating version"

version=$(grep -oP '(?<=__version__ = ")[^"]*' $FILE)
major=$(echo $version | cut -d. -f1)
minor=$(echo $version | cut -d. -f2)
micro=$(echo $version | cut -d. -f3)

if [ "$TYPE" = "major" ]
then
  major=$((major+1)) 
  minor=0 
  micro=0
elif [ "$TYPE" = "minor" ]
then
  minor=$((minor+1)) 
  micro=0
elif [ "$TYPE" = "micro" ] 
then
  micro=$((micro+1)) 
else
  echo "Invalid version type"
  exit 1
fi
new_version=$(echo "$major.$minor.$micro")
echo "Old Version: ${version} -> New Version: ${new_version}"
sed -i "s/__version__ = \"$version\"/__version__ = \"$new_version\"/g" $FILE
