cmake_minimum_required(VERSION 3.0)

project(libSGMBuilder)

find_package(CUDA REQUIRED)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/libSGM/archive/d62610687e70bb1d890342b3dc00d8917c9ecc30.tar.gz)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )


# Select the correct CUDA flags for the supported architectures 
if(BINPKGS_CUDA_ARCHS) 
    CUDA_SELECT_NVCC_ARCH_FLAGS(ARCH_CUDA_FLAGS ${BINPKGS_CUDA_ARCHS}) 
else() 
    # No BinPkgs configuration file for whatever reason, just build for every arch under the sun. 
    CUDA_SELECT_NVCC_ARCH_FLAGS(ARCH_CUDA_FLAGS "All") 
endif() 

string (REPLACE ";" " " ARCH_CUDA_FLAGS_STR "${ARCH_CUDA_FLAGS}")

list(APPEND CUDA_NVCC_FLAGS ${ARCH_CUDA_FLAGS_STR})

set(libSGM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DCUDA_NVCC_FLAGS:STRING=${CUDA_NVCC_FLAGS}
                      -DCUDA_HOST_COMPILER:STRING=${CUDA_HOST_COMPILER}
                      -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
                      -DLIBSGM_SHARED:BOOL=ON
)

if(UNIX)
    list(APPEND libSGM_CMAKE_ARGS -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF)
else()
    list(APPEND libSGM_CMAKE_ARGS -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=ON)
endif()

if(WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /FS")
    list(APPEND libSGM_CMAKE_ARGS -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS})
endif()

ExternalProject_Add(
    libSGM
    URL ${CACHED_URL}
    URL_HASH SHA256=43e1863e76ad9d79f8d37687553c071a1f0d8db8f180cfa932020ef88a199c10
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR "${CMAKE_INSTALL_PREFIX}"
    CMAKE_ARGS ${libSGM_CMAKE_ARGS}
)
