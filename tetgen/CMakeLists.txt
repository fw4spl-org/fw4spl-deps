cmake_minimum_required(VERSION 3.0)

project(tetgenBuilder)

include(ExternalProject)

set(TETGEN_CMAKE_ARGS ${COMMON_CMAKE_ARGS})
set(TETGEN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

set(CACHED_URL http://www.tetgen.org/1.5/src/tetgen1.5.0.tar.gz)

ExternalProject_Add(
    tetgen
    URL ${CACHED_URL}
    URL_HASH SHA256=4d114861d5ef2063afd06ef38885ec46822e90e7b4ea38c864f76493451f9cf3
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${TETGEN_PATCH_DIR}/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${TETGEN_CMAKE_ARGS}
)

ExternalProject_Add_Step(tetgen CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindTetgen.cmake ${CMAKE_INSTALL_PREFIX}/FindTetgen.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)

