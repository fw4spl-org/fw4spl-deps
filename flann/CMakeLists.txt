cmake_minimum_required(VERSION 3.0)

project(flannBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/mariusmuja/flann/archive/1.8.4.zip)

set(FLANN_CMAKE_ARGS    ${COMMON_CMAKE_ARGS}
                        -DBUILD_C_BINDINGS:BOOL=OFF
                        -DBUILD_MATLAB_BINDINGS:BOOL=OFF
                        -DBUILD_PYTHON_BINDINGS:BOOL=OFF
)

# Patch to disabled tests and examples (compilation error on win32)
set(FLANN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

set(FLANN_PATCH_COMMAND  ${CMAKE_COMMAND} -E copy ${FLANN_PATCH_DIR}/CMakeLists.txt ${CMAKE_CURRENT_BINARY_DIR}/flann-prefix/src/flann/CMakeLists.txt)
set(FLANN_PATCH_COMMAND  ${FLANN_PATCH_COMMAND} 
                 COMMAND ${CMAKE_COMMAND} -E copy ${FLANN_PATCH_DIR}/serialization.h ${CMAKE_CURRENT_BINARY_DIR}/flann-prefix/src/flann/src/cpp/flann/util/serialization.h)

ExternalProject_Add(
    flann
    URL ${CACHED_URL}
    URL_HASH SHA256=22dfa2ef97b696f7ea5bf5b44aaa8590067244cddcfa1f6837f0c0d8c88c6e5c
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FLANN_CMAKE_ARGS}
    PATCH_COMMAND ${FLANN_PATCH_COMMAND}
)

