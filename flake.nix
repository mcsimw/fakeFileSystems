{
  description = "My new flake with merged nixosModules";

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
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (
    { lib, self, ... }:
    {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      flake.nixosModules = lib.mkMerge [
        (inputs.nix-genesis.lib.dirToAttrs ./nixosModules)
        {
          zfsos = lib.modules.importApply ./nixosModules/zfsos { localFlake = self; };
        }
      ];
    }
  );
}

