cmake_minimum_required(VERSION 3.0)

project(tetgenBuilder)

include(ExternalProject)

set(TETGEN_CMAKE_ARGS ${COMMON_CMAKE_ARGS})
set(TETGEN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

set(CACHED_URL http://http.debian.net/debian/pool/main/t/tetgen/tetgen_1.5.0.orig.tar.gz)

set(TETGEN_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${TETGEN_PATCH_DIR}/CMakeLists.txt.diff -d <SOURCE_DIR>)

ExternalProject_Add(
    tetgen
    URL ${CACHED_URL}
    URL_HASH SHA256=4d114861d5ef2063afd06ef38885ec46822e90e7b4ea38c864f76493451f9cf3
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${TETGEN_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${TETGEN_CMAKE_ARGS}
)

fwInstallFile(
    BINPKG tetgen
    SRC ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindTetgen.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindTetgen.cmake
)
