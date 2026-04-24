#!/bin/bash
[ -f .env ] && export $(grep -v '^#' .env | xargs) || echo "No .env found"

SOURCE="${SHP_SOURCE_DIR:-./}"
DEST="${CSV_OUT_DIR:-./gis-output/csv/}"

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
    echo "CSV Processing: $filename"

    OUT_PATH="$DEST/$filename.csv"

    # Explicitly clear the specific target file to avoid driver confusion
    [ -f "$OUT_PATH" ] && rm "$OUT_PATH"
    
    # -overwrite: Destroys existing file before writing fresh
    # --config GDAL_NON_INTERACTIVE YES: Reduces chatter
    # 2>/dev/null: Silences the Integer64 -> Real type warnings
    ogr2ogr -f "CSV" \
            "$OUT_PATH" \
            "$shp_file" \
            -t_srs "EPSG:4326" \
            -lco GEOMETRY=AS_WKT

done

echo "SHP to CSV Conversion complete. Files located in $DEST"
