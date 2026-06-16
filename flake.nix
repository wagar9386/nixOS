{
    description = "Hyprland NixOS waga";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { nixpkgs, home-manager, ... }: 
    let
        system = "x86_64-linux";
    in
    {
        nixosConfigurations.goti-nixOS = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true; 
                        useUserPackages = true;
                        users.agar = import ./home/default.nix;
                    };
                }
            ];
        };

        homeConfigurations.agar = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [ ./home.nix ];
        };
    };
}
