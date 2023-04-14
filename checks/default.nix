{ self, system }:
let pkgs = self.inputs.nixpkgs.legacyPackages.${system};

in {
  pre-commit = self.inputs.pre-commit-hooks.lib.${system}.run {
    src = self;
    hooks = {
      # Builtin hooks
      deadnix.enable = true;
      nixfmt.enable = true;
      prettier.enable = true;
      statix.enable = false;
      typos.enable = true;

      # Custom hooks
      statix-write = {
        enable = true;
        name = "Statix Write";
        entry = "${pkgs.statix}/bin/statix fix";
        language = "system";
        pass_filenames = false;
      };
    };

    # Settings for builtin hooks, see also: https://github.com/cachix/pre-commit-hooks.nix/blob/master/modules/hooks.nix
    settings = {
      deadnix.edit = true;
      nixfmt.width = 120;
      prettier.write = true;
    };
  };
}
