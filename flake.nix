{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:RobbieBuxton/nixpkgs/dlib-cuda-fix";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.cudaSupport = true;
        config.allowUnfree = true;
        overlays = [
          (self: super: {
            dlib = super.callPackage ./default.nix { };
          })
        ];
      };
      concatStringsWithSpace = pkgs.lib.strings.concatStringsSep " ";
      cudaLibs =
        if pkgs.config.cudaSupport then [
          "-lcudart"
          "-lcudnn"
          "-lcublas"
          "-lcurand"
          "-lcusolver"
        ] else [ ];
      effectiveStdenv = if pkgs.config.cudaSupport then pkgs.cudaPackages.backendStdenv else pkgs.stdenv;

    in
    {
      packages.${system} = {
        default = effectiveStdenv.mkDerivation {
          pname = "dlib-test";
          version = "0.0.1";
          src = ./.;

          buildInputs = [
            pkgs.dlib
            # pkgs.openturns
            # pkgs.python311Packages.face-recognition
          ]
          ++ pkgs.lib.optionals pkgs.config.cudaSupport (with pkgs.cudaPackages; [
            cuda_cudart
            cuda_nvcc.dev
            libcublas
            libcurand
            libcusolver
            cudnn
          ]);

          buildPhase =
            let
              sources = [
                "main.cpp"
              ];
              libs = [
                "-ldlib"
              ] ++ cudaLibs;
              headers = [
                "-I ${pkgs.dlib}/include"
              ];
            in
            ''
              g++ ${
                concatStringsWithSpace
                (sources ++ libs ++ headers)
              } -o dlib-test
            '';

          installPhase = ''
            mkdir -p $out/bin
            cp dlib-test $out/bin
          '';
        };
      };
    };
}
