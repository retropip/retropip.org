{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {

    devShell.x86_64-linux = pkgs.stdenv.mkDerivation {
      name = "retropip.com";
      buildInputs = with pkgs; [
        entr
        gnumake
        wrangler
      ];
    };

  };
}
