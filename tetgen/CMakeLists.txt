cmake_minimum_required(VERSION 3.0)

project(tetgenBuilder)

include(ExternalProject)

set(TETGEN_CMAKE_ARGS ${COMMON_CMAKE_ARGS})
set(TETGEN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

set(CACHED_URL http://tetgen.org/files/tetgen1.4.3.tar.gz)

ExternalProject_Add(
    tetgen
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${TETGEN_PATCH_DIR}/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${TETGEN_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(tetgen CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindTetgen.cmake ${CMAKE_INSTALL_PREFIX}/FindTetgen.cmake
    COMMENT "Install configuration file"
)

