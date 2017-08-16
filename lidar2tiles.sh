#!/bin/bash

# min and max zoom levels for tiles created
# max 17 seems about right for 1M resolution LIDAR
MINZOOM=12
MAXZOOM=17
# DTM ZIP files should have same names but with 'DTM' instead of 'DSM'
DSM_PATTERN="LIDAR-DSM-*.zip"

# check that required applications are installed
for name in unzip sed gdalbuildvrt gdal_calc.py gdaldem gdal2tiles.py; do
	hash $name 2>/dev/null \
		|| { echo >&2 "$name not found. Aborting."; exit 1; }
done

# check that there is at least one DSM ZIP file
for f in $DSM_PATTERN; do
	if ! [ -f $f ]; then
		echo "Cannot find any files matching $DSM_PATTERN"
		exit 1
	fi
done

# check that each DSM ZIP file has a DTM equivalent
for this_dsm in $DSM_PATTERN; do
	if ! [ -f `echo $this_dsm | sed 's/DSM/DTM/'` ]; then
		echo "Cannot find DTM equivalent for $this_dsm. Aborting."
		exit 1
	fi
done

echo "Unzipping and creating VRT file for each ZIP file"
for f in *.zip; do
	dir=`basename $f .zip`
	# unzip each file into its own directory
	unzip -q $f -d $dir || exit 1
	# create a VRT file for each directory
	gdalbuildvrt $dir.vrt $dir/*.asc
done

echo "Calculating feature heights"
# use command to prevent trailing *s if ls has been aliased to ls -F
for f in `command ls $DSM_PATTERN | sed 's/.zip/.vrt/'`; do
	# calculate surface minus terrain i.e. features
	gdal_calc.py -A $f -B `echo $f | sed 's/DSM/DTM/'` \
		--calc="A-B" \
		--outfile=`echo $f | sed 's/.vrt/-features.tiff/'` \
		|| exit 1
done

echo "Creating VRT files for whole area"
# assemble features GeoTIFFs into single VRT
gdalbuildvrt LIDAR-features.vrt *-features.tiff

# create new VRT using colour map
gdaldem color-relief \
	LIDAR-features.vrt colourmap.txt LIDAR-features-colour.vrt \
	-alpha -of VRT

echo "Creating tiles"
gdal2tiles.py LIDAR-features-colour.vrt tiles \
	-z $MINZOOM-$MAXZOOM -w leaflet -s EPSG:27700

echo "Removing intermediate files"
# use command to prevent trailing *s if ls has been aliased to ls -F
rm -rf `command ls $DSM_PATTERN | sed 's/.zip//'`
rm -rf `command ls $DSM_PATTERN | sed 's/DSM/DTM/' | sed 's/.zip//'`
rm -f `command ls $DSM_PATTERN | sed 's/.zip/.vrt/'`
rm -f `command ls $DSM_PATTERN | sed 's/DSM/DTM/' | sed 's/.zip/.vrt/'`
