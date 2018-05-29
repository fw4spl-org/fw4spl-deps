cmake_minimum_required(VERSION 2.8)

project(GlogBuilder)

include(ExternalProject)

#download glog version (Apr 26, 2018) to fix build error on Windows
set(CACHED_URL https://github.com/google/glog/archive/2faa186e62d544e930305ffd8f8e507b2054cc9b.tar.gz)

set(GLOG_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DBUILD_TESTING:BOOL=OFF
                    -DWITH_GFLAGS:BOOL=OFF
                    -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -std=c++11
)

ExternalProject_Add(
        glog
        URL ${CACHED_URL}
        URL_HASH SHA256=8b9f9fd4b1fe7991774f70b1700b022baf8255501f9ec736356e147323a3ab84
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DOWNLOAD_NAME glog-0.3.5-rev-2faa186.tar.gz
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${GLOG_CMAKE_ARGS}
)
