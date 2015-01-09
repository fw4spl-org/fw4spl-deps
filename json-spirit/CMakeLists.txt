cmake_minimum_required(VERSION 2.8)

project(json-spiritBuilder)

include(ExternalProject)
getCachedUrl(https://github.com/greenjava/json-spirit/archive/json-spirit_4.08.tar.gz CACHED_URL)

ExternalProject_Add(
    json-spirit
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${COMMON_CMAKE_ARGS}
)
