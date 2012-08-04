#!/bin/bash
rate=$1   # average bitrate (VBR)
indir=$2  # source directory
outdir=$3 # destination directory

supported="mp3 flac" # list of supported input types
ext="ogg"

######################
#  HELPER FUNCTIONS  #
######################

printerr ()
{
  echo >&2 "ABORTING: $1";
  exit 1;
}

test_exist ()
{
  # look in $1 for files that end with .$2
  # succeed if any matches were found
  files=`find "$1" -type f -iname "*.$2" | wc -l`
  return `test "$files" != "0"`
}

####################
#  INITIALIZATION  #
####################

# verify existence of input directory
test -d "$indir" || printerr "input directory not found: \"$indir\""

# verify existence of supported input files
found=0
for ext_i in $supported; do
  test_exist "$indir" "$ext_i" &&
  {
    (( found++ ));
    echo "found $ext_i";
  }
done
test $found -eq 0 && printerr "no supported input types found."

# check dependencies
hash oggenc 2>&- || printerr "oggenc requred."
test_exist "$indir" "mp3" &&
{
  {hash mpg321 2>&- && mpg="mpg321"} ||
  {hash mpg123 2>&- && mpg="mpg123"} ||
    printerr "mpg321 or mpg123 requred."
}

# make sure the output file exists
test -d "$outdir" || mkdir "$outdir"
test -d "$outdir" || printerr "output directory could not be created."

################
#  CONVERSION  #
################

# PROCEDURE: mp3
for input in "$indir"/*.{mp3,MP3}; do
  output="$outdir"/${input%.*}.$ext
  $mpg "$input" -w - | oggenc - -b $rate -o "$output"
done

# PROCEDURE: flac
for input in "$indir"/*.{flac,FLAC}; do
  output="$outdir"/${input%.*}.$ext
  oggenc "$input" -b $rate -o "$output"
done
