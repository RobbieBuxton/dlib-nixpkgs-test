#include <iostream>
#include <opencv2/core.hpp>
#include <dlib/dnn.h>

int main()
{
    #ifdef DLIB_USE_CUDA
        std::cout << "Dlib is compiled with CUDA support." << std::endl;
    #else
        std::cout << "Dlib is not compiled with CUDA support." << std::endl;
    #endif

    #ifdef DLIB_USE_BLAS
        std::cout << "Dlib is compiled with BLAS support." << std::endl;
    #else
        std::cout << "Dlib is not compiled with BLAS support." << std::endl;
    #endif

    #ifdef DLIB_USE_LAPACK
        std::cout << "Dlib is compiled with LAPACK support." << std::endl;
    #else
        std::cout << "Dlib is not compiled with LAPACK support." << std::endl;
    #endif

    #ifdef __AVX__
        std::cout << "AVX on" << std::endl;
    #else
        std::cout << "AVX off" << std::endl;
    #endif

    #ifdef DLIB_HAVE_SSE2
        std::cout << "DLIB_HAVE_SSE2 on" << std::endl;
    #else
        std::cout << "DLIB_HAVE_SSE2 off" << std::endl;
    #endif

    #ifdef DLIB_HAVE_SSE3
        std::cout << "DLIB_HAVE_SSE3 on" << std::endl;
    #else
        std::cout << "DLIB_HAVE_SSE3 off" << std::endl;
    #endif

    #ifdef DLIB_HAVE_SSE41
        std::cout << "DLIB_HAVE_SSE41 on" << std::endl;
    #else
        std::cout << "DLIB_HAVE_SSE41 off" << std::endl;
    #endif

    #ifdef DLIB_HAVE_AVX
        std::cout << "DLIB_HAVE_AVX on" << std::endl;
    #else
        std::cout << "DLIB_HAVE_AVX off" << std::endl;
    #endif

    return 0;
}