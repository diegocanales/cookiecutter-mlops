#!/bin/bash

## Usage
# bash ci/release/check_current_branch.sh

# Check current branch
CURRENT_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
if [ "master" = "$CURRENT_BRANCH" ] || [ "main" = "$CURRENT_BRANCH" ];
then
    echo "Current branch is $CURRENT_BRANCH"
else
    echo "Error: Current branch must be master or main."
    exit 1
fi
