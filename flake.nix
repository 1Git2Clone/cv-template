{
  description = "LaTeX toolchain for the CV";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
      systems,
      ...
    }:
    let
      forAll = nixpkgs.lib.genAttrs (import systems);

      # texliveSmall plus exactly the packages cv.tex \usepackage's. Defined
      # once and shared by the hook and both shells, so the compile that gates
      # a commit is byte-for-byte the one a developer runs by hand. It used to
      # be spelled out twice and the two copies were free to drift.
      texFor =
        pkgs:
        pkgs.texliveSmall.withPackages (
          ps: with ps; [
            latexmk
            preprint
            tools
            titlesec
            marvosym
            enumitem
            hyperref
            fancyhdr
            babel-english
            xcolor
          ]
        );
    in
    {
      checks = forAll (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              markdownlint = {
                enable = true;
                args = [
                  "-c"
                  ".markdownlint.json"
                ];
              };

              # The two nix linters the CI shell has always carried. Until they
              # were enabled here nothing ran them, so the shell listed tools
              # that could not fail a build.
              nixfmt-rfc-style.enable = true;
              statix.enable = true;

              latex-compile = {
                enable = true;
                name = "LaTeX compile check";
                entry = "latexmk";
                args = [
                  "-pdf"
                  "-interaction=nonstopmode"
                  "cv.tex"
                ];
                pass_filenames = false;

                # ONE backslash pair. Nix collapses "\\." to the two characters
                # \. which is what the regex engine must see. Writing "\\\\."
                # here yields \\. — a literal backslash followed by any
                # character — which matches no filename in this repo, so the
                # hook reported "(no files to check)Skipped" on every run and
                # the CV was never actually compiled by CI.
                files = "\\.tex$";

                extraPackages = [ (texFor pkgs) ];
              };
            };
          };
        }
      );

      devShells = forAll (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pre-commit-check = self.checks.${system}.pre-commit-check;
        in
        {
          default = pkgs.mkShell {
            buildInputs = pre-commit-check.enabledPackages ++ [
              (texFor pkgs)
              pkgs.texlab
            ];
            inherit (pre-commit-check) shellHook;
          };

          # What .forgejo/workflows/ci.yml and .github/workflows/ci.yml enter.
          # buildInputs comes from enabledPackages rather than a hand-written
          # list: a hook enabled above is then automatically on PATH here, and
          # the previous hand-written list had drifted — it carried nixfmt and
          # statix for hooks that did not exist and omitted the latexmk the
          # latex-compile hook shells out to.
          ci = pkgs.mkShell {
            buildInputs = pre-commit-check.enabledPackages ++ [
              pkgs.pre-commit
              pkgs.git
            ];
            inherit (pre-commit-check) shellHook;
          };
        }
      );
    };
}
