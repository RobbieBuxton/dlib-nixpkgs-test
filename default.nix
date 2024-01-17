{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libpng
, libjpeg
, libwebp
, blas
, lapack
, config
, guiSupport ? false
, libX11
, fetchpatch
, sse4Support ? stdenv.hostPlatform.sse4_1Support
, avxSupport ? stdenv.hostPlatform.avxSupport
, cudaSupport ? config.cudaSupport
, cudaPackages
}@inputs:
(if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv).mkDerivation rec {
  pname = "dlib";
  version = "19.24.2";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev = "v${version}";
    sha256 = "sha256-Z1fScuaIHjj2L1uqLIvsZ7ARKNjM+iaA8SAtWUTPFZk=";
  };

  #remove once fixed https://github.com/davisking/dlib/issues/2833#issuecomment-1885902146
  patches = [ ] ++ lib.optionals
    cudaSupport
    [
      (fetchpatch
      {
        url = "https://github.com/conda-forge/dlib-feedstock/raw/cf9148326a7ad74c1dd519c2d3d5dc2912f9697c/recipe/use_new_cudatoolkit.patch";
        sha256 = "sha256-10YDsy5v4WTJll3ej4LEZ/ApwL0J7oZuIMhSigIernQ=";
      })
    ];

  postPatch = ''
    rm -rf dlib/external
  '';

  cmakeFlags = [
    (lib.cmakeBool "USE_SSE4_INSTRUCTIONS" sse4Support)
    (lib.cmakeBool "USE_AVX_INSTRUCTIONS" avxSupport)
    (lib.cmakeBool "DLIB_USE_CUDA" cudaSupport)
  ] ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "DLIB_USE_CUDA_COMPUTE_CAPABILITIES" (builtins.concatStringsSep "," (with cudaPackages.flags; map dropDot cudaCapabilities)))
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional cudaSupport (with cudaPackages; [
    cuda_nvcc
  ]);

  REBUILD_HACK = "s";

  buildInputs = [
    libpng
    libjpeg
    libwebp
    blas
    lapack
  ]
  ++ lib.optional guiSupport libX11
  ++ lib.optionals config.cudaSupport (with cudaPackages; [
    cuda_cudart
    cuda_nvcc.dev
    libcublas
    libcurand
    libcusolver
    cudnn
  ]);

  passthru = {
    inherit
      cudaSupport cudaPackages
      sse4Support avxSupport;
  };

  meta = with lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = "http://www.dlib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ];
    platforms = platforms.unix;
  };
}
