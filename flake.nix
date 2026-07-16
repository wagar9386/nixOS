{
    description = "Hyprland NixOS waga";

    inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    deemix.url = "github:bambanah/deemix"; #test
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
};
    
    outputs = { nixpkgs, home-manager, sops-nix, deemix, ... }: 
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
    			extraSpecialArgs = {
  				 inherit sops-nix deemix;
			                   };    			
			sharedModules = [ sops-nix.homeManagerModules.sops ];
			};           
		 }
            ];
        };

        homeConfigurations.agar = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [ ./home/default.nix];
        };
    };
}
