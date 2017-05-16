#!/usr/bin/env bash

COLOR_RED=$(printf '\e[0;31m')
COLOR_DEFAULT=$(printf '\e[m')
ICON_CROSS=$(printf $COLOR_RED'✘'$COLOR_DEFAULT)

ROOT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
HOOKS_DIR=$(dirname $SCRIPT_PATH)

if [ -f "$HOOKS_DIR/git-flow-hooks-config.sh" ]; then
    . "$HOOKS_DIR/git-flow-hooks-config.sh"
fi

if [ -f "$ROOT_DIR/.git/git-flow-hooks-config.sh" ]; then
    . "$ROOT_DIR/.git/git-flow-hooks-config.sh"
fi

function __print_fail {
    echo -e "  $ICON_CROSS $1"
}

function __get_commit_files {
    echo $(git diff-index --name-only --diff-filter=ACM --cached HEAD --)
}

function __get_version_file {
    if [ -z "$VERSION_FILE" ]; then
        VERSION_FILE="VERSION"
    fi

    echo "$ROOT_DIR/$VERSION_FILE"
}

function __get_hotfix_version_bumplevel {
    if [ -z "$VERSION_BUMPLEVEL_HOTFIX" ]; then
        VERSION_BUMPLEVEL_HOTFIX="PATCH"
    fi

    echo $VERSION_BUMPLEVEL_HOTFIX
}

function __get_release_version_bumplevel {
    if [ -z "$VERSION_BUMPLEVEL_RELEASE" ]; then
        VERSION_BUMPLEVEL_RELEASE="MINOR"
    fi

    echo $VERSION_BUMPLEVEL_RELEASE
}

function __is_binary {
    P=$(printf '%s\t-\t' -)
    T=$(git diff --no-index --numstat /dev/null "$1")

    case "$T" in "$P"*) return 0 ;; esac

    return 1
}

# Bianca
function __read_semver_json {
    # grep -Po '"text":.*?[^\\]",' tweets.json 
    # -P is missing in OSX, replaced by -E
    # jq .semver '.[0] | { major: .Major, minor: .Minor, patch: .Patch, prereleasetag: .PreReleaseTag, semver: .SemVer }'

    # This is to determine increments (Regex for integers)
    MAJOR=`grep -Eo '"Major":(\d*?,|.*?[^\\]",)' .semver | awk -F':' '{print $2}'`
    MINOR=`grep -Eo '"Minor":(\d*?,|.*?[^\\]",)' .semver | awk -F':' '{print $2}'`
    PATCH=`grep -Eo '"Patch":(\d*?,|.*?[^\\]",)' .semver | awk -F':' '{print $2}'`

    # This is used for the branch name (Regex for String)
    MAJORMINORPATCH=`grep -Eo '"MajorMinorPatch":.*?[^\\]",' .semver | awk -F':' '{print $2}'`
    
    # This is used for tagging if needed
    SEMVER=`grep -Eo '"SemVer":.*?[^\\]",' .semver | awk -F':' '{print $2}'`
}
