{
  inputs.nixpkgs.url = "nixpkgs";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cargo
              rustc
              stdenv.cc
              lld
              dbus
              pkg-config
              openssl
            ];
            
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
              stdenv.cc.cc.lib
              dbus
	      openssl
            ]);
          };
        }
      );
    };
}