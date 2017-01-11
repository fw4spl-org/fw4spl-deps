cmake_minimum_required(VERSION 3.0)

project(json-spiritBuilder)

include(ExternalProject)
set(CACHED_URL https://github.com/fw4spl-org/json-spirit/archive/json-spirit_4.08.tar.gz)

ExternalProject_Add(
    json-spirit
    URL ${CACHED_URL}
    URL_HASH SHA256=9cedb5cd1876b9736a4298464406fdb41fd27c2329f789b9369ab151cd1b68c0
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${COMMON_CMAKE_ARGS}
)
