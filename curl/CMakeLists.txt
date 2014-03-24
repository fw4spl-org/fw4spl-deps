CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(curlBuilder)

INCLUDE(ExternalProject)

SET(CURL_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                    -DBUILD_CURL_EXE:BOOL=OFF
                    -DBUILD_CURL_TESTS:BOOL=OFF
                    -DCURL_STATICLIB:BOOL=OFF
                    -DCURL_USE_ARES:BOOL=OFF
                    -DBUILD_DASHBOARD_REPORTS:BOOL=OFF
                    -DCURL_ZLIB:BOOL=ON
                    -DCMAKE_USE_OPENSSL:BOOL=OFF #@todo: enable openssl
)
GET_CACHED_URL(http://curl.haxx.se/download/curl-7.27.0.tar.gz CACHED_URL)

ExternalProject_Add(
    curl
    DEPENDS zlib
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CURL_CMAKE_ARGS}
)


