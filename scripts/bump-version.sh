#!/usr/bin/env bash

CURRENT_VERSION=$(npm pkg get version | tr -d '"')
GIT_COUNT=$(git rev-list --count HEAD)

MAJOR=$(( $(( $GIT_COUNT )) / 1000 ))
MINOR=$(( $(( $GIT_COUNT )) % 1000 / 100 ))
PATCH=$(( $(( $GIT_COUNT )) % 1000 % 100 + 1 ))
NEW_VERSION=$MAJOR.$MINOR.$PATCH

if [ "$CURRENT_VERSION" != "$NEW_VERSION" ]; then
    npm version $NEW_VERSION --git-tag-version false
fi