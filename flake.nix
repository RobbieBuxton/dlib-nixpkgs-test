{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:RobbieBuxton/nixpkgs/dlib-cuda-fix";
    # nixpkgs.url = "github:NixOS/nixpkgs/23.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.cudaSupport = true;
        config.allowUnfree = true;
      };

      dlib = (pkgs.dlib.override {
        guiSupport = true;
        avxSupport = true;
        sse4Support = true;
      });

      concatStringsWithSpace = pkgs.lib.strings.concatStringsSep " ";
    in
    {
      packages.${system} = {
        default = pkgs.cudaPackages.backendStdenv.mkDerivation {
          pname = "dlib-test";
          version = "0.0.1";
          src = ./.;

          buildInputs = [
            pkgs.python310Packages.glad2
            # Libs
            pkgs.assimp
            dlib
            pkgs.opencv
            pkgs.libpng
            pkgs.libjpeg
            pkgs.cudatoolkit
            pkgs.cudaPackages.cudnn
            pkgs.linuxPackages.nvidia_x11
            pkgs.xorg.libX11
            pkgs.xorg.libXrandr
            pkgs.xorg.libXi
            pkgs.udev
            pkgs.fftw
          ];
          buildPhase =
            let
              sources = [
                "main.cpp"
              ];
              libs = [
                "-lX11"
                "-lXrandr"
                "-lXi"
                "-ldl"
                "-lm"
                "-ludev"
                "-lopencv_core"
                "-lopencv_imgproc"
                "-lopencv_highgui"
                "-lopencv_imgcodecs"
                "-lopencv_cudafeatures2d"
                "-lopencv_cudafilters"
                "-lopencv_cudawarping"
                "-lopencv_features2d"
                "-lopencv_flann"
                "-ldlib"
                "-lcudart"
                "-lcuda"
                "-lcudnn"
                "-lcublas"
                "-lcurand"
                "-lcusolver"
                "-lfftw3"
              ];
              headers = [
                "-I ${pkgs.opencv}/include/opencv4"
                "-I ${dlib}/include"
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
