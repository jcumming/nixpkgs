{ callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.3.2";
  branch = "4.3";
  sha256 = "0flik4y7c5kchj65p3p908mk1dsncqgzjdvzysjs12rmf1m6sfmb";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
  patches = [ ( fetchpatch { 
    name = "SRTO_SMOOTHER-SRTO_STRICTENC";
    url = "https://git.videolan.org/?p=ffmpeg.git;a=patch;h=7c59e1b0f285cd7c7b35fcd71f49c5fd52cf9315";
    sha256 = "sha256:1jkzylr9nc0d6j0hdff4w02kiddrva1349ba3nb3nka466j6dakn";
  } ) ];
} // args)
