#!/usr/bin/env bash

function clearCaches {
    KEY_PATTERN="$1"
    echo -e "\nFetching list of cache keys for $2..."
    cacheKeys=$(gh actions-cache list -R $REPO -B main --key $KEY_PATTERN --sort created-at --order desc | cut -f 1 )
    noOfCacheKeys=$(echo "$cacheKeys" | wc -l)
    echo "Found $noOfCacheKeys $2 cache keys, deleting $(expr $noOfCacheKeys - 1) cache(s)."

    ## Setting this to not fail the workflow while deleting cache keys. 
    set +e
    for cacheKey in $(tail -n +2 <<< "$cacheKeys")
    do
        echo "Deleting $2 cache: $cacheKey"
        gh actions-cache delete $cacheKey -R $REPO -B main --confirm
    done
}

gh extension install actions/gh-actions-cache
clearCaches "node-cache-Linux-npm-" "NPM"
echo -e "\nCache deletion done!"