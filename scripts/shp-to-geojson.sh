#!/bin/bash

# load CWD .env file to environment
#export $(grep -v '^#' .env | xargs)
[ -f .env ] && export $(grep -v '^#' .env | xargs) || echo "No .env found"

# Default values if not provided in env
SOURCE="${SHP_SOURCE_DIR:-./}"
DEST="${GEOJSON_OUT_DIR:-./gis-output/geojson}"
LAT="${ORIGIN_LATITUDE}"
LON="${ORIGIN_LONGITUDE}"

SHP_COUNT=$(find "$SOURCE" -maxdepth 1 -name "*.shp" | wc -l)
if [ "$SHP_COUNT" -eq 0 ]; then
    echo "Error: No .shp files found in $SOURCE"
    exit 1
fi
echo "Found $SHP_COUNT SHP file(s) in $SOURCE"

# Create output directory if it doesn't exist
mkdir -p "$DEST"

echo "Starting SHP to GEOJSON conversion ..."
echo "Origin: $LAT, $LON"

for shp_file in "$SOURCE"/*.shp; do
    [ -e "$shp_file" ] || continue
    
    filename=$(basename -- "$shp_file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    echo "Processing: $filename"

    # ogr2ogr conversion
    # -t_srs: Transforms to WGS84
    # -lco COORDINATE_PRECISION: Keeps the file size down for your web app
    ogr2ogr -f "GeoJSON" \
            "$DEST/$filename.json" \
            "$shp_file" \
            -t_srs "EPSG:4326" \
            -lco COORDINATE_PRECISION=7

done

echo "SHP to GEOJSON Conversion complete. Files located in $DEST"
