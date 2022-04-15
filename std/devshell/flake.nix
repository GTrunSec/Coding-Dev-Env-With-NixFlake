{
  description = "Standard development shell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.main.url = "path:../.";
  outputs = inputs:
    inputs.flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] (
      system: let
        inherit (inputs.main.inputs.std.deSystemize system inputs) main devshell nixpkgs;
      in {
        devShells.default = devshell.legacyPackages.mkShell (
          {
            extraModulesPath,
            pkgs,
            ...
          }: {
            name = "Standard";
            packages = [
              # formatters
              nixpkgs.legacyPackages.alejandra
              nixpkgs.legacyPackages.shfmt
              nixpkgs.legacyPackages.nodePackages.prettier
            ];
            commands = [
              {
                package = nixpkgs.legacyPackages.treefmt;
                category = "formatters";
              }
              {
                package = nixpkgs.legacyPackages.editorconfig-checker;
                category = "formatters";
              }
              {
                package = nixpkgs.legacyPackages.reuse;
                category = "legal";
              }
            ];
            imports = [
              "${extraModulesPath}/git/hooks.nix"
            ];
          }
        );
      }
    );
}
