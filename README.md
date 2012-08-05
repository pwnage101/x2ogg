x2ogg
=====

Convert anything into ogg vorbis. Currently "anything" is just mp3 and flac.

Usage:
```
x2ogg average-bitrate source-dir dest-dir 
```

average-bitrate is the desired averate bitrate (VBR) of the output ogg vorbis
files.

x2ogg will non-recursively search source-dir for audio files, convert them to
ogg, then write them to dest-dir.

Example:
```bash
$ ls music/
track1.flac track2.flac track3.FLAC  
$ x2ogg 150 music/ music/ogg
...
$ ls music/ogg/
track1.ogg track2.ogg track3.ogg
```
