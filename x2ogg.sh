#!/bin/bash
rate=$1   # average bitrate (VBR)
indir=$2  # source directory
outdir=$3 # destination directory

supported="mp3 flac"
ext=ogg

printerr() { echo >&2 $1; exit 1; }

test_exist() {
# look in $1 for files that end with .$2
# return true if any matches were found
  files=`find "$1" -type f -iname "*.$2" | wc -l`
  return `test "$files" != "0"`
}

####################
#  INITIALIZATION  #
####################

# verify existence of input directory and any supported files
test -d "$indir" || printerr "Input directory not found: $indir"
found=0
for ext_i in $supported; do
  test_exist "$indir" "$ext_i" && { (( found++ )); echo "found $ext_i"; }
done
test $found -eq 0 && printerr "No supported input types found."

# check dependencies
hash oggenc 2>&- || printerr "oggenc requred. Aborting."
test_exist "$indir" "mp3" && {
  hash mpg321 2>&- || hash mpg123 2>&- || printerr "mpg321 or mpg123 requred. Aborting."
}

# create output file
mkdir "$outdir"

################
#  CONVERSION  #
################

# PROCEDURE: mp3
for input in "$indir"/*.mp3; do
  output="$outdir"/`basename "$input" .mp3`.$ext
  mpg123 "$input" -w - | oggenc - -b $rate -o "$output"
done

# PROCEDURE: flac
for input in "$indir"/*.flac; do
  output="$outdir"/`basename "$input" .flac`.$ext
  oggenc "$input" -b $rate -o "$output"
done
