{ lib, stdenv
, fetchFromGitHub
, runCommand
, python
, texlive
, inkcut
}:

{
  hexmap = stdenv.mkDerivation {
    name = "hexmap";
    version = "2020-06-06";

    src = fetchFromGitHub {
      owner = "lifelike";
      repo = "hexmapextension";
      rev = "11401e23889318bdefb72df6980393050299d8cc";
      sha256 = "1a4jhva624mbljj2k43wzi6hrxacjz4626jfk9y2fg4r4sga22mm";
    };

    preferLocalBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/inkscape/extensions"
      cp -p *.inx *.py "$out/share/inkscape/extensions/"
      find "$out/share/inkscape/extensions/" -name "*.py" -exec chmod +x {} \;

      runHook postInstall
    '';

    meta = with lib; {
      description = "This is an extension for creating hex grids in Inkscape. It can also be used to make brick patterns of staggered rectangles";
      homepage = "https://github.com/lifelike/hexmapextension";
      license = licenses.gpl2Plus;
      maintainers = [ maintainers.raboof ];
      platforms = platforms.all;
    };
  };

  inkcut = (runCommand "inkcut-inkscape-plugin" {} ''
    mkdir -p $out/share/inkscape/extensions
    cp ${inkcut}/share/inkscape/extensions/* $out/share/inkscape/extensions
  '');

  inkscapeMadeEasy = stdenv.mkDerivation { 
    name = "inkscapeMadeEasy";
    version = "2020-10-16";

    src = fetchFromGitHub {
      owner = "fsmMLK";
      repo = "inkscapeMadeEasy";
      rev = "10490819e4f53ce3457eacc2b6ebb6f4fc85d250";
      sha256 = "sha256-W+67Enw+sK/mwOjyCZmudu5t8s3lv9PskawTT0ugRbg=";
    };

    preferLocalBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/inkscape/extensions/inkscapeMadeEasy/"
      cp -p latest/* "$out/share/inkscape/extensions/inkscapeMadeEasy/"
      find "$out/share/inkscape/extensions/inkscapeMadeEasy/" -name "*.py" -exec chmod +x {} \;

      runHook postInstall
    '';

    meta = with lib; {
      description = "functions to help the development of new extensions for Inkscape";
      homepage = "https://github.com/fsmMLK/inkscapeMadeEasy";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.jcumming ];
      platforms = platforms.all;
    };
  };

  circuitSymbols = stdenv.mkDerivation { 
    name = "circuitSymbols";
    version = "2020-12-21";

    src = fetchFromGitHub {
      owner = "fsmMLK";
      repo = "inkscapeCircuitSymbols";
      rev = "ac2fec9ef345ba63fcda229f224fff32131dbd31";
      sha256 = "sha256-8mkLq4TR0ft7fS3YyqEHzyp9B/E0Albdwk6qYSxplig=";
    };

    preferLocalBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/inkscape/extensions"
      cp -p latest/* "$out/share/inkscape/extensions/"
      find "$out/share/inkscape/extensions/" -name "*.py" -exec chmod +x {} \;

      runHook postInstall
    '';

    meta = with lib; {
      description = "assist creating electric symbols";
      homepage = "https://github.com/fsmMLK/inkscapeCircuitSymbols";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.jcumming ];
      platforms = platforms.all;
    };
  };

  logicGates = stdenv.mkDerivation { 
    name = "logicGates";
    version = "2020-10-10";

    src = fetchFromGitHub {
      owner = "fsmMLK";
      repo = "inkscapeLogicGates";
      rev = "c192ab4052ea5fd675a063c469a9b3ecbc5ff45a";
      sha256 = "sha256-lg8TgtQ8xJ2neywNNFWft967Pj1dRFIPP5ti+oWMlc4=";
    };

    preferLocalBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/inkscape/extensions"
      cp -p latest/* "$out/share/inkscape/extensions/"
      find "$out/share/inkscape/extensions/" -name "*.py" -exec chmod +x {} \;

      runHook postInstall
    '';

    meta = with lib; {
      description = "latches, flip-flops and logic gates following the 'distinctive shape' of IEEE Std 91/91a-1991 standarda";
      homepage = "https://github.com/fsmMLK/inkscapeLogicGates";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.jcumming ];
      platforms = platforms.all;
    };
  };

  textext = stdenv.mkDerivation { 
    name = "textext";
    version = "1.3.1";

    src = fetchFromGitHub {
      owner = "textext";
      repo = "textext";
      rev = "1.3.1";
      sha256 = "sha256-Wx+daYRUg0w7CHjUdpjIU1WKqNzRytwxLeU/Oil/Ams=";
    };

    buildInputs = [
      python
      texlive.combined.scheme-small # for building the documentation
    ];

    installPhase = ''
      runHook preInstall

      set -x
      mkdir -p "$out/share/inkscape/extensions"
      python ./setup.py \
        --skip-requirements-check \
        --pdflatex-executable=${texlive.combined.scheme-small}/bin/pdflatex \
        --inkscape-extensions-path=$out/share/inkscape/extensions

      runHook postInstall
    '';

    meta = with lib; {
      description = "latches, flip-flops and logic gates following the 'distinctive shape' of IEEE Std 91/91a-1991 standarda";
      homepage = "https://github.com/fsmMLK/inkscapeLogicGates";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.jcumming ];
      platforms = platforms.all;
    };
  };

}
