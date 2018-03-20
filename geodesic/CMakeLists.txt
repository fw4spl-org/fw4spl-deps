cmake_minimum_required(VERSION 3.0)

project(geodesicBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/jabooth/exactgeodesic/archive/b5c2cc4a59193e7cee6cd84c9378696e053b931a.tar.gz)

ExternalProject_Add(
    geodesic
    URL ${CACHED_URL}
    URL_HASH SHA256=b86542500e39008595442a9a9008fd5fa70f8d843bcbd34ad733078b0d113ad5
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME geodesic.tar.gz
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_CURRENT_BINARY_DIR}/geodesic-prefix/src/geodesic" "${CMAKE_INSTALL_PREFIX}/include/geodesic"
    INSTALL_COMMAND ""
)

fwInstallFile(
    BINPKG geodesic
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/fw-geodesic.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/fw-geodesic.cmake
)
