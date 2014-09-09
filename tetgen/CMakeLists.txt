cmake_minimum_required(VERSION 2.8)

project(tetgenBuilder)

include(ExternalProject)

set(TETGEN_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
set(TETGEN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

getCachedUrl(http://tetgen.org/files/tetgen1.4.3.tar.gz CACHED_URL)

ExternalProject_Add(
    tetgen
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${TETGEN_PATCH_DIR}/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${TETGEN_CMAKE_ARGS}
)


  