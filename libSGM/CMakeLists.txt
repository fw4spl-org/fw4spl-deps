cmake_minimum_required(VERSION 3.0)

project(libSGMBuilder)

find_package(CUDA REQUIRED)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/libSGM/archive/d62610687e70bb1d890342b3dc00d8917c9ecc30.tar.gz)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(libSGM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DCUDA_ARCH_BIN:STRING=${BINPKGS_CUDA_ARCHS}
                      -DCUDA_HOST_COMPILER:STRING=${CUDA_HOST_COMPILER}
                      -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
)
list(APPEND libSGM_CMAKE_ARGS -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=ON)

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
