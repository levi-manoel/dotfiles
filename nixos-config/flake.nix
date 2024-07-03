{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    apple-fonts.url = "github:ostmarco/apple-fonts.nix";
    catppuccin.url = "github:catppuccin/nix";

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    apple-fonts,
    catppuccin,
    # rust-overlay,
    ...
  }: let
    systems = with flake-utils.lib.system; [
      aarch64-darwin
      x86_64-darwin
      x86_64-linux
    ];

    systemsFlakes = flake-utils.lib.eachSystem systems (system: let
      inherit (lib.extra) mapModulesRec';

      overlays = [
        (import overlays/electron.nix)
        # (rust-overlay.overlays.default)
      ];

      lib = pkgs.lib.extend (self: super: {
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

        overlays =
          overlays
          ++ [
            (final: prev: apple-fonts.packages.${system})
          ];
      };

      mkHost = path: let
        inherit (builtins) baseNameOf;
        inherit (lib) mkDefault removeSuffix;
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit pkgs lib inputs system;};
          modules =
            [
              {
                nixpkgs.pkgs = pkgs;
                networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
              }

              home-manager.nixosModule
              catppuccin.nixosModules.catppuccin

              (import path)
            ]
            ++ mapModulesRec' ./modules import;
        };
    in {
      nixosConfigurations = {
        red = mkHost ./hosts/red;
      };
    });

    system = "x86_64-linux";
  in
    systemsFlakes
    // {
      nixosConfigurations = systemsFlakes.nixosConfigurations.${system};
    };
}
