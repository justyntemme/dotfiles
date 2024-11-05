{
  description = "Shell config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    repository = {
      url = "github:justyntemme/dotfiles";
    };
  };

  outputs = { self, nixpkgs, repository }: 
  let
    pkgs = import nixpkgs { system = "aarch64-darwin"; };
  in {
    packages.aarch64-darwin.shellConfig = pkgs.buildEnv {
      name = "shell-config";
      paths = [
        (pkgs.writeTextFile {
          name = "init.lua";
          destination = "/Users/${builtins.getEnv "USER"}/.config/nvim/init.lua"
          text = builtins.readFile "${repository}/work/init.lua";
        })
        (pkgs.writeTextFile {
          name = "zshrc";
          destination = "/Users/${builtins.getEnv "USER"}/.zshrc";
          text = builtins.readFile "${repository}/zshrc";
        })
        (pkgs.writeTextFile {
            name = "kitty.conf";
            destination = "/Users/${builtins.getEnv "USER"}/.config/kitty/kitty.conf";
            text = builtins.readFile "${repository}/kitty.conf";
        })
      ];
    };
  };
}
