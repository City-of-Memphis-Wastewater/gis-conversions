#!/bin/bash

# load CWD .env file to environment
[ -f .env ] && export $(grep -v '^#' .env | xargs) || echo "No .env found"
SOURCE="${SHP_SOURCE_DIR:-./}"

check_shp_count() {
    local src="$1"
    
    shp_count=$(find "$src" -maxdepth 1 -name "*.shp" | wc -l)

    if [ "$shp_count" -eq 0 ]; then
        echo "Error: No .shp files found in $drc"
        return 1
    fi
    echo "Found $shp_count SHP file(s) in $src"
}
check_shp_count "$SOURCE" || exit 1
