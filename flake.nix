{
  description = "zoiper5 package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs =
    {
      self,
      nixpkgs,
    }:
    {
      packages.x86_64-linux.default =
        with import nixpkgs { system = "x86_64-linux"; };
        let
          src = fetchurl {
            url = "https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/linux";
            sha256 = "sha256-YEig6L9oLDKlYLBKNurS/eTApJF2U4CJxtUnv72k5VQ=";
            curlOptsList = [ "-b PHPSESSID=XXX" ];
          };
          build = stdenv.mkDerivation {
            pname = "zoiper5";
            version = "5.6.9";

            src = src;

            sourceRoot = ".";

            unpackPhase = ":";

            installPhase = ''
              mkdir -p "$out/opt"
              mkdir -p "$out/bin"
              tar -C "$out/opt" -xvf ${src}
              ln -s ../opt/Zoiper5/zoiper "$out/bin"
            '';

            meta = with lib; {
              description = "Voip softphone";
              homepage = "https://www.zoiper.com/";
              # license = licenses.unfree;
              platforms = platforms.linux;
              architectures = [ "x86" ];
            };

            dontPatchELF = true;
            dontStrip = true;
          };
        in
        pkgs.buildFHSEnv {
          name = "zoiper";
          targetPkgs =
            pkgs: with pkgs; [
              alsa-lib
              at-spi2-core
              build
              cairo
              cups
              dbus
              expat
              fontconfig
              freetype
              gdk-pixbuf
              glib
              gtk2
              krb5
              libdrm
              libgbm
              libGL
              libnotify
              libpulseaudio
              libv4l
              libva
              libxkbcommon
              mesa
              nspr
              nss
              pango
              pciutils
              xorg.libX11
              xorg.libXcomposite
              xorg.libXdamage
              xorg.libXext
              xorg.libXi
              xorg.libXrandr
              xorg.libXScrnSaver
              zlib
            ];
          runScript = "zoiper";
        };
    };
}
