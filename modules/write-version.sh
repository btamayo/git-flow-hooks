#!/usr/bin/env bash 

VERSION_FILE=$(__get_version_file)
VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)

# http://stackoverflow.com/a/21358850
# ${PARAMETER/PATTERN/STRING}
# PATTERN can also include anchors, to match it either at the beginning or the end; namely # and %:
# ----------
# MYSTRING=ABCCBA
# echo ${MYSTRING/#A/y}  # RESULT: yBCCBA
# echo ${MYSTRING/%A/y}  # RESULT: ABCCBy
# ----------
# 
# You can also use a variable for PATTERN - and skip the slashes to 
# add to the confusion (and replace the pattern match with an empty string):
# ----------
# echo ${MYSTRING#$PATTERN}  # RESULT: BCCBA
# echo ${MYSTRING%$PATTERN}  # RESULT: ABCCB
# ----------

if [ ! -z "$VERSION_PREFIX" ]; then
    VERSION=${VERSION#$VERSION_PREFIX}
fi

if [ -z "$VERSION_BUMP_MESSAGE" ]; then
    VERSION_BUMP_MESSAGE="Bump version to %version%"
fi

echo -n "$VERSION" > $VERSION_FILE && \
    git add $VERSION_FILE && \
    git commit -m --allow-empty "$(echo "$VERSION_BUMP_MESSAGE" | sed s/%version%/$VERSION/g)"

if [ $? -ne 0 ]; then
    __print_fail "Unable to write version to $VERSION_FILE."
    return 1
else
    return 0
fi
