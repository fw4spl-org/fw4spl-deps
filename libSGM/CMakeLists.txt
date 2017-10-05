cmake_minimum_required(VERSION 3.0)

project(libSGMBuilder)

find_package(CUDA REQUIRED)

include(ExternalProject)

set(CACHED_URL https://github.com/fixstars/libSGM/archive/72c24d76d0ed267d224427398dc7ffb52effe2a3.zip)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(libSGM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DCUDA_ARCH_BIN:STRING=${FW4SPL_CUDA_ARCHS}
                      -DCUDA_HOST_COMPILER:STRING=${CUDA_HOST_COMPILER})
set(libSGM_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(libSGM_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i "${libSGM_PATCH_DIR}/rm_samples_and_tweak_cuda_arch.diff" -d "<SOURCE_DIR>")

list(APPEND libSGM_CMAKE_ARGS -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=ON)

if(WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /FS")
    list(APPEND libSGM_CMAKE_ARGS -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS})
endif()

ExternalProject_Add(
    libSGM
    URL ${CACHED_URL}
    URL_HASH SHA256=4bc3c43e7fb856b6716f212cdbd6b2ccbece2b26aa6ccd08126ce166639c07a9
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND "${libSGM_PATCH_CMD}"
    INSTALL_DIR "${CMAKE_INSTALL_PREFIX}"
    CMAKE_ARGS ${libSGM_CMAKE_ARGS}
)

ExternalProject_Add_Step(libSGM CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindLibSGM.cmake ${CMAKE_INSTALL_PREFIX}/FindLibSGM.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
