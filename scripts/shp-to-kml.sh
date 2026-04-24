#!/bin/bash
[ -f .env ] && export $(grep -v '^#' .env | xargs) || echo "No .env found"

SOURCE="${SHP_SOURCE_DIR:-./}"
DEST="${KML_OUT_DIR:-./gis-output/kml/}"

SHP_COUNT=$(find "$SOURCE" -maxdepth 1 -name "*.shp" | wc -l)
if [ "$SHP_COUNT" -eq 0 ]; then
    echo "Error: No .shp files found in $SOURCE"
    exit 1
fi
echo "Found $SHP_COUNT SHP file(s) in $SOURCE"

mkdir -p "$DEST"

for shp_file in "$SOURCE"/*.shp; do
    [ -e "$shp_file" ] || continue
    filename=$(basename -- "$shp_file")
    filename="${filename%.*}"
    echo "KML Processing: $filename"

    # KML natively uses WGS84
    ogr2ogr -f "KML" "$DEST/$filename.kml" "$shp_file" -t_srs "EPSG:4326"
done

echo "SHP to KML Conversion complete. Files located in $DEST"
