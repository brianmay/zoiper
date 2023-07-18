{
  description = "zoiper5 package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      let
        src = fetchurl {
          url = "https://shop.zoiper.com/download.php?id=BDOPCQJIVA2V538";
          sha256 = "sha256-qzqSaqfSQ1ESjWQG5TbpED4OePXjZWFsjpb5XJTpTy4=";
        };
      in stdenv.mkDerivation {
        pname = "zoiper5";
        version = "21.07.0";

        src = src;

        nativeBuildInputs = [ autoPatchelfHook ];

        buildInputs = [
          alsa-lib
          at-spi2-core
          cairo
          cups
          dbus
          expat
          gdk-pixbuf
          gnome2.libgnome
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
        ];

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
      };
  };

}
