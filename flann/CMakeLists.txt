cmake_minimum_required(VERSION 3.0)

project(flannBuilder)

include(ExternalProject)

set(CACHED_URL http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.8.4-src.zip)

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
    URL_HASH SHA256=dfbb9321b0d687626a644c70872a2c540b16200e7f4c7bd72f91ae032f445c08
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FLANN_CMAKE_ARGS}
    PATCH_COMMAND ${FLANN_PATCH_COMMAND}
)

