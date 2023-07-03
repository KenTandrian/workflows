#!/usr/bin/env bash

function clearCaches {
    KEY_PATTERN="$1"
    echo -e "\nFetching list of cache keys for $2..."
    cacheKeys=$(gh actions-cache list -R $REPO -B main --key $KEY_PATTERN --sort created-at --order desc | cut -f 1,3 )
    noOfCacheKeys=$(echo "$cacheKeys" | sed '/^\s*$/d' | wc -l) || 0
    toDelete=$(( $noOfCacheKeys - 1 >= 0 ? $noOfCacheKeys - 1 : 0 ))
    echo "Found $(( $noOfCacheKeys )) $2 cache keys, deleting $toDelete cache(s)."

    if [ $toDelete -eq 0 ]; then
        echo "Cache for $2 is clean! ✨"
        exit 0
    fi
    
    ## Setting this to not fail the workflow while deleting cache keys. 
    set +e
    echo "$(tail -n +2 <<< "$cacheKeys")" | while read -r line; do
        cacheKey=$(echo "$line" | cut -f 1)
        branch=$(echo "$line" | cut -f 2)
        echo "Deleting $2 cache: $cacheKey @ $branch"
        gh actions-cache delete $cacheKey -R $REPO -B $branch --confirm
    done
}

gh extension install actions/gh-actions-cache
clearCaches "node-cache-Linux-npm-" "NPM"
echo -e "\nCache deletion done!"