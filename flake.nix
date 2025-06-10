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
          src = ./Zoiper5_5.6.9_x86_64.tar.xz;
        in
        stdenv.mkDerivation {
          pname = "zoiper5";
          version = "5.6.9";

          src = src;

          nativeBuildInputs = [
            autoPatchelfHook
            pkgs.makeWrapper
          ];

          buildInputs = [
            alsa-lib
            at-spi2-core
            cairo
            cups
            dbus
            expat
            gdk-pixbuf
            gtk2
            krb5
            libdrm
            libnotify
            libpulseaudio
            libv4l
            libxkbcommon
            mesa
            nss
            pango
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXrandr
            xorg.libXScrnSaver
            libva
            pciutils
          ];

          sourceRoot = ".";

          unpackPhase = ":";

          installPhase = ''
            mkdir -p "$out/opt"
            mkdir -p "$out/bin"
            tar -C "$out/opt" -xvf ${src}
            ln -s ../opt/Zoiper5/zoiper "$out/bin"
            wrapProgram $out/bin/zoiper \
              --prefix LD_LIBRARY_PATH : ${
                lib.makeLibraryPath [
                  systemd
                  libGL
                ]
              }
          '';

          meta = with lib; {
            description = "Voip softphone";
            homepage = "https://www.zoiper.com/";
            # license = licenses.unfree;
            platforms = platforms.linux;
            architectures = [ "x86" ];
          };
        };
    };
}
