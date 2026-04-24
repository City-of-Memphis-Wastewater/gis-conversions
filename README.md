# Maxson Plant GIS Transpiler

A zero-footprint, environment-aware utility suite for converting ESRI Shapefiles into various web and engineering formats. Optimized for high-fidelity mapping of municipal assets (wastewater, piping, and electrical) and integration into Three.js digital twins or CAD workflows.

Features
- Multi-Format Support: Bulk conversion to GeoJSON, KML, CSV, and DXF.
- Environment Decoupling: Uses .env files for site-specific coordinates and paths.
- Dependency Lite: Pure Shell/Bash wrapper around GDAL—no complex runtime environments.

Use Case at Maxson
- **Interoperability**: Bridges the gap between ArcGIS Shapefiles and open-web standards.
- **Engineering CAD**: Generates DXF files projected in Tennessee State Plane West (EPSG:2274) for immediate use in AutoCAD.
- **DCS Alignment**: Ideal for mapping Ovation DCS database points to spatial geometries.

## Prerequisites
- **GDAL/ogr2ogr**: The core engine for this tool.
  ```bash
  sudo apt install gdal-bin
  ```

## Setup
1. Clone the repository and navigate to the root.

    ```bash
    git clone git@github.com:City-of-Memphis-Wastewater/gis-conversions.git
    cd gis-conversions
    ```

2. Create a `.env` file (see `.env.example` for the template):

    ```bash
    cp .env.example .env
    nano .env
    ```
    Edit the `SHP_SOURCE_DIR` value to point to the `.shp` files you want to convert. 
    Otherwise, the current directory will be used.

3. Enable and run the script of your choice.

    ```bash
    chmod +x scripts/shp-to-geojson.sh
    ./scripts/shp-to-geojson.sh
    ```

## Usage
### Bulk Conversion

Each script in the scripts/ directory handles a specific format. They all leverage the same .env configuration.

|**Command**|**Output Format**|**Primary Use Case**|
|---|---|---|
|`./scripts/shp-to-geojson.sh`|`.geojson`|Three.js / Web Dashboards|
|`./scripts/shp-to-kml.sh`|`.kml`|Google Earth / Mobile GIS|
|`./scripts/shp-to-csv.sh`|`.csv`|Database Audits / Excel|
|`./scripts/shp-to-dxf.sh`|`.dxf`|AutoCAD / Plant Engineering|


## Manual Conversion (One-off)
If you need to process a single file outside of the bulk workflow, call `ogr2ogr` directly:
```bash
ogr2ogr -f "GeoJSON" output.json input.shp -t_srs "EPSG:4326" -lco COORDINATE_PRECISION=7
ogr2ogr -f "CSV" output.csv input.shp -lco GEOMETRY=AS_WKT
```
This is how the conversions work under the hood.

## Credits & Acknowledgments
- **GDAL / ogr2ogr**: This tool is a humble wrapper for the [GDAL](https://gdal.org/) library.
- **City of Memphis DPW**: Developed for the T.E. Maxson Wastewater Treatment Facility mapping initiative.

## License
MIT License - Feel free to leverage, modify, and distribute.

## Example

### Succesful SHP to KML conversion then KML import to Google Earth

<p align="center">
  <img src="https://raw.githubusercontent.com/City-of-Memphis-Wastewater/gis-conversions/main/assets/kml-import-to-google-earth.png" width="100%" alt="Succesful SHP to KML conversion then KML import to Google Earth">
</p>
