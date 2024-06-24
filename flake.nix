{
  description = "a flake for 1lab";

  # 1lab nixpkgs is actually pinned, this is a bit of a noop
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/6cfbf89825dae72c64188bb218fd4ceca1b6a9e3";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs @ {
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        pkgs,
        ...
      }: {
        packages.default = (pkgs.callPackage ./. {
          inNixShell = false;
          interactive = false;
        }).overrideAttrs (o: {
          nativeBuildInputs = (pkgs.lib.lists.filter (p: p != pkgs.gitMinimal) o.nativeBuildInputs) ++ [
            (pkgs.writeShellScriptBin "git" ''
                while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
                  --git-dir)
                    shift;
                    ;;
                esac; shift; done
                if [[ "$1" == '--' ]]; then shift; fi
                case $1 in
                  ls-files )
                    ${pkgs.findutils}/bin/find .         -type f -maxdepth 1
                    ${pkgs.findutils}/bin/find ./src     -type f
                    ${pkgs.findutils}/bin/find ./support -type f
                    exit
                    ;;
                  rev-parse )
                    echo "HEAD-dirty"
                    exit
                    ;;
                  shortlog )
                    echo "authors"
                    exit
                    ;;
                esac;
                echo "unaccounted case: $@"
                exit 1
              '')
          ];
        });
        devShells.default = (pkgs.callPackage ./. {inNixShell = true;}).overrideAttrs (o: {
          src = null;
        });
      };
    };

  nixConfig = {
    copyGitDirectory = true;
    extra-substituters = "https://1lab.cachix.org";
    extra-trusted-public-keys = "1lab.cachix.org-1:eYjd9F9RfibulS4OSFBYeaTMxWojPYLyMqgJHDvG1fs=";
  };
}
