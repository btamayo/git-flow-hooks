#!/usr/bin/env bash

echo MESSAGE
echo "format-tag-message"

if [ -z "$VERSION_TAG_PLACEHOLDER" ]; then
    VERSION_TAG_PLACEHOLDER="%tag%"
fi

MESSAGE=$(echo "$MESSAGE" | sed s/$VERSION_TAG_PLACEHOLDER/$VERSION-yomama/g)
