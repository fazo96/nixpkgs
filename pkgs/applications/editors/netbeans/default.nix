{stdenv, fetchurl, jdk, unzip, which, makeWrapper, makeDesktopItem}:

let
  desktopItem = makeDesktopItem {
    name = "netbeans";
    exec = "netbeans";
    comment = "Integrated Development Environment";
    desktopName = "Netbeans IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
  };
in
stdenv.mkDerivation rec {
  name = "netbeans-${version}";
  version = "8.0.2";
  date = "201411181905";
  src = fetchurl {
    url = "http://download.netbeans.org/netbeans/${version}/final/zip/netbeans-${version}-${date}.zip";
    sha256 = "bb9f31d45746263ce34f4ea138b963c8525934c9797cec88b50c66abf9c52cc1";
  };
  buildCommand = ''
    # Unpack and copy the stuff
    unzip $src
    mkdir -p $out
    cp -a netbeans $out
    
    # Create a wrapper capable of starting it
    mkdir -p $out/bin
    makeWrapper $out/netbeans/bin/netbeans $out/bin/netbeans \
      --prefix PATH : ${jdk}/bin:${which}/bin \
      --prefix JAVA_HOME : ${jdk.home} \
      --add-flags "--jdkhome ${jdk.home}"
      
    # Create desktop item, so we can pick it from the KDE/GNOME menu
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
  
  buildInputs = [ unzip makeWrapper ];
  
  meta = {
    description = "An integrated development environment for Java, C, C++ and PHP";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
