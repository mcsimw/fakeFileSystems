{
  description = "";
  outputs =
    inputs:
    inputs.nix-genesis.mkFlake { inherit inputs; } (
      { lib, config, ... }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        perSystem.treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            dos2unix.enable = true;
          };
        };
        imports = [
          inputs.nix-genesis.fmt
          "${inputs.nix-genesis.outPath}/lib.nix"
        ];
        flake.nixosModules = config.flake.lib.dirToAttrs ./nixosModules;
      }
    );
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
    };
    nix-genesis = {
      type = "github";
      owner = "mcsimw";
      repo = "nix-genesis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
