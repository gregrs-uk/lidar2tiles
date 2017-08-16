# lidar2tiles

A BASH script which uses [GDAL](http://www.gdal.org) to process the [Environment Agency's LIDAR data](http://environment.data.gov.uk/ds/survey) and create map tiles of surface features which can be viewed in a browser or used in JOSM.

Map tiles are coloured based on the height of surface features such as buildings and trees, calculated by subtracting the DTM from the DSM. By default, features below 1m in height are transparent, becoming red and opaque at 2m. There is a gradient through orange to yellow at 20m, then a more gradual gradient to white at 60m.

## Usage

* Download one or more ZIP files of LIDAR DSM data and their DTM equivalents from the [Environment Agency](http://environment.data.gov.uk/ds/survey) e.g. `LIDAR-DSM-1M-TR15ne.zip` and `LIDAR-DTM-1M-TR15ne.zip`. Place them in the same directory as `lidar2tiles.sh`.
* If you wish, alter the colour map by editing `colourmap.txt`. See the [`gdaldem` documentation](http://www.gdal.org/gdaldem.html#gdaldem_color_relief) for details. N.B. `colourmap.txt` uses alpha values in addition to RGB values.
* `cd` to the directory containing `lidar2tiles.sh` and run it (`./lidar2tiles.sh`).
* The map tiles are placed in the `tiles` directory. Within this directory, `leaflet.html` can be used to browse the tiles.
* The TIFF and VRT files created are not required but can be loaded into QGIS if you wish to examine the data to determine building heights, for example.
* To use the tiles in JOSM, click on Imagery > Imagery Preferences, click on the '+ TMS' button and enter the URL e.g. `file:///home/user/Desktop/lidar2tiles/tiles/{zoom}/{x}/{-y}.png` (note the `-y`) and a name for the layer. The layer will appear in the Imagery menu.

## Copyright

Copyright &copy; gregrs-uk 2017, published under the GNU GPL v3.0
