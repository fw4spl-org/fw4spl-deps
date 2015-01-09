cmake_minimum_required(VERSION 2.8)

project(curlBuilder)

include(ExternalProject)

set(CURL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_CURL_EXE:BOOL=OFF
                    -DBUILD_CURL_TESTS:BOOL=OFF
                    -DCURL_STATICLIB:BOOL=OFF
                    -DCURL_USE_ARES:BOOL=OFF
                    -DBUILD_DASHBOARD_REPORTS:BOOL=OFF
                    -DCURL_ZLIB:BOOL=ON
                    -DCMAKE_USE_OPENSSL:BOOL=OFF #@todo: enable openssl
)
getCachedUrl(https://github.com/bagder/curl/archive/curl-7_38_0.tar.gz CACHED_URL)

ExternalProject_Add(
    curl
    DEPENDS zlib
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CURL_CMAKE_ARGS}
)


