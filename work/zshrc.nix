{
  description = "Flake for my Zsh configuration";

  outputs = { self, nixpkgs }: {
    defaultPackage.aarch64-darwin = nixpkgs.pkgs.writeShellScriptBin "set-zshrc" ''
      #!/usr/bin/env bash
      ln -sf ${self}/.zshrc $HOME/.zshrc
    '';
  };
}

