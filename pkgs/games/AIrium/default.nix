{ stdenv, fetchurl, jre8, libX11, libXext, libXcursor, libXrandr, libXxf86vm
, mesa }:

stdenv.mkDerivation rec {
  name = "AIrium-${version}";
  version = "v0.5.0";

  src = fetchurl {
    url = "https://github.com/fazo96/AIrium/releases/download/v0.5.0/AIrium_v0.5.0.jar";
    sha256 = "08aydmssdq521k3kcg2bl7s1dp8idq2lnc5rg6x53xrxz8rpgpas";
  };

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out/bin
    cp -v $src $out/AIrium.jar

    cat > $out/bin/AIrium << EOF
    #!${stdenv.shell}

    # wrapper for AIrium
    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${stdenv.cc.cc}/lib/:${libX11}/lib/:${libXext}/lib/:${libXcursor}/lib/:${libXrandr}/lib/:${libXxf86vm}/lib/:${mesa}/lib/
    ${jre8}/bin/java -jar $out/AIrium.jar
    EOF

    chmod +x $out/bin/AIrium
  '';

}
