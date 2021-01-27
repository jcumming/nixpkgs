{ callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.3.1";
  branch = "4.3";
  sha256 = "1nghcpm2r9ir2h6xpqfn9381jq6aiwlkwlnyplxywvkbjiisr97l";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
  patches = [ ( fetchpatch { 
    name = "SRTO_SMOOTHER-SRTO_STRICTENC";
    url = "https://git.videolan.org/?p=ffmpeg.git;a=patch;h=7c59e1b0f285cd7c7b35fcd71f49c5fd52cf9315";
    sha256 = "sha256:1jkzylr9nc0d6j0hdff4w02kiddrva1349ba3nb3nka466j6dakn";
  } ) ];
} // args)
