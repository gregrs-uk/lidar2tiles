# lidar2tiles

A BASH script which uses [GDAL](http://www.gdal.org) to process the [Environment Agency's LIDAR data](http://environment.data.gov.uk/ds/survey) and create map tiles of surface features which can be viewed in a browser or used in JOSM.

Map tiles are coloured based on the height of surface features such as buildings and trees, calculated by subtracting the DTM from the DSM. By default, features below 1m in height are transparent, becoming red and opaque at 2m. There is a gradient through orange to yellow at 20m, then a more gradual gradient to white at 60m.

## Usage

### Downloading LIDAR data

* Download one or more ZIP files of LIDAR **Composite** DSM data and their DTM equivalents from the [Environment Agency](https://environment.data.gov.uk/DefraDataDownload/?Mode=survey) e.g. `LIDAR-DSM-1M-TR15ne.zip` and `LIDAR-DTM-1M-TR15ne.zip`. Place these ZIP files in the same directory as `lidar2tiles.sh`.
* If multiple resolutions of the same area are provided, the script will combine them, favouring higher-resolution data.
* You may find the [coverage index](https://environment.maps.arcgis.com/apps/webappviewer/index.html?id=f765c2a97d644f08927d5cd5abe58d87) helpful in determining which resolutions to download.

### Altering the colour map (optional)

* If you wish, alter the colour map by editing `colourmap.txt`. See the [`gdaldem` documentation](http://www.gdal.org/gdaldem.html#gdaldem_color_relief) for details. N.B. `colourmap.txt` uses alpha values in addition to RGB values.

### Running the script

* `cd` to the directory containing `lidar2tiles.sh` and run it (`./lidar2tiles.sh`).

### Using the output files

* The map tiles are placed in the `tiles` directory. Within this directory, `leaflet.html` can be used to browse the tiles.
* The TIFF and VRT files created are not required but can be loaded into QGIS if you wish to examine the data to determine building heights, for example.
* To use the tiles in JOSM, click on Imagery > Imagery Preferences, click on the '+ TMS' button and enter the URL e.g. `file:///home/user/Desktop/lidar2tiles/tiles/{zoom}/{x}/{-y}.png` (note the `-y`) and a name for the layer. The layer will appear in the Imagery menu.

## Copyright

Copyright &copy; gregrs-uk 2017, published under the GNU GPL v3.0
