cmake_minimum_required(VERSION 2.8)

project(annBuilder)

include(ExternalProject)

getCachedUrl(http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.tar.gz CACHED_URL)

set(ANN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(ANN_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                   -DBUILD_SHARED_LIBS:BOOL=ON
)

# Makefile for Mac/Linux exits, but it's a mess
ExternalProject_Add(
    ann
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${ANN_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ANN_CMAKE_ARGS}
)
