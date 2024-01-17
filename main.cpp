#include <iostream>
#include <dlib/dnn.h>
#include <dlib/cuda/cuda_dlib.h>
#include <vector>


int main()
{
#ifdef DLIB_USE_CUDA
    std::cout << "Dlib is compiled with CUDA support." << std::endl;
    int device_count = dlib::cuda::get_num_devices();
    std::cout << "Dlib cuda devices count: " << device_count << std::endl;
    for (int i = 0; i < device_count; ++i)
    {
        std::cout << "Device " << i << " name: " << dlib::cuda::get_device_name(i) << std::endl;
        std::cout << "Device " << i << " name: " << dlib::cuda::get_device() << std::endl;
    }
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
    return 0;
}