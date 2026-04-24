#!/bin/bash

# load CWD .env file to environment
#export $(grep -v '^#' .env | xargs)
[ -f .env ] && export $(grep -v '^#' .env | xargs) || echo "No .env found"

SOURCE="${SHP_SOURCE_DIR:-./}"
DEST="${DXF_OUT_DIR:-./gis-output/dxf/}"
# Default to Tennessee West (Feet) if not provided
SRS="${DXF_SRS:-EPSG:2274}"

SHP_COUNT=$(find "$SOURCE" -maxdepth 1 -name "*.shp" | wc -l)
if [ "$SHP_COUNT" -eq 0 ]; then
    echo "Error: No .shp files found in $SOURCE"
    exit 1
fi
echo "Found $SHP_COUNT SHP file(s) in $SOURCE"

mkdir -p "$DEST"

echo "Starting SHP to DXF conversion..."
echo "Target Projection: $SRS"

for shp_file in "$SOURCE"/*.shp; do
    [ -e "$shp_file" ] || continue
    filename=$(basename -- "$shp_file")
    filename="${filename%.*}"

    echo "Processing: $filename"

    # -zfield: Includes elevation if present
    # -dsco: Header allows older CAD versions to read it
    ogr2ogr -f "DXF" \
            "$DEST/$filename.dxf" \
            "$shp_file" \
            -t_srs "$SRS" \
            -skipfailures
done

echo "SHP to DXF Conversion complete. Files located in $DEST"
