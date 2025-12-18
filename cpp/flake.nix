{
  description = "C++ project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      git-hooks,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        projectName = builtins.baseNameOf (builtins.toString ./.);
        gccVersion = pkgs.gcc.cc.version;
        nixSymlinkDir = "/tmp/gcc-${gccVersion}";

        cppPackage = pkgs.stdenv.mkDerivation {
          pname = projectName;
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [ pkgs.cmake ];
          buildInputs = [ pkgs.clang ];

          cmakeFlags = [
            "-DCMAKE_CXX_COMPILER=${pkgs.clang}/bin/clang++"
          ];

          buildPhase = ''
            cmake .
            cmake --build .
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ${projectName} $out/bin/ || cp ./main $out/bin/${projectName}
          '';
        };

        preCommitCheck = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };
            statix = {
              enable = true;
              settings.format = "stderr";
            };
            deadnix.enable = true;
            clang-format = {
              enable = true;
              types = [
                "c"
                "c++"
                "c-header"
              ];
            };
          };
        };
      in
      {
        checks = {
          pre-commit-check = preCommitCheck;
        };

        packages.default = cppPackage;

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            pkgs.cmake
            pkgs.clang
          ];
          packages = with pkgs; [
            cmake
            clang
            clang-tools
            lldb
            gdb
            nixd
            nixfmt-classic
            watchexec
            nushell
            helix
          ];

          shellHook = ''
            export CC=clang
            export CXX=clang++

            # Create short symlinks to Nix store paths for readable diagnostics
            ln -sfn ${pkgs.gcc.cc}/include/c++/*/ ${nixSymlinkDir}
            export NIX_SYMLINK_DIR="${nixSymlinkDir}"

            ${preCommitCheck.shellHook}
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.lib.getExe cppPackage}";
        };

        formatter = pkgs.nixfmt-classic;
      }
    );
}
