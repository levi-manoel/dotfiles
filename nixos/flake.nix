{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    stylix,
    ...
  }: let
    systems = with flake-utils.lib.system; [
      aarch64-darwin
      x86_64-darwin
      x86_64-linux
    ];

    systemsFlakes = flake-utils.lib.eachSystem systems (system: let
      inherit (lib.extra) mapModulesRec';

      lib = nixpkgs.lib.extend (self: super: {
        extra = import ./lib {
          inherit inputs;

          pkgs = nixpkgs.legacyPackages.${system};
          lib = self;
        };
      });

      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfree = true;
        config.permittedInsecurePackages = ["electron-25.9.0"];
      };

      mkHost = path: let
        inherit (builtins) baseNameOf;
        inherit (lib) mkDefault removeSuffix;
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs system lib;};
          modules =
            [
              {
                nixpkgs.pkgs = pkgs;
              }

              home-manager.nixosModule
              stylix.nixosModules.stylix

              (import path)
            ]
            ++ mapModulesRec' ./modules import;
        };
    in {
      nixosConfigurations = {
        batcomputer = mkHost ./hosts/batcomputer;
      };
    });

    system = "x86_64-linux";
  in
    systemsFlakes
    // {
      nixosConfigurations = systemsFlakes.nixosConfigurations.${system};
    };
}