{
    description = "Hyprland NixOS waga";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { nixpkgs, home-manager, ... }: {
        nixosConfigurations.goti-nixOS = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true; 
                        useUserPackages = true;
                        users.agar = import ./home.nix;

                   };
                    
                }
            ];
        };
    };
}
