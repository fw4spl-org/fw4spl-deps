cmake_minimum_required(VERSION 2.8)

project(GlogBuilder)

include(ExternalProject)

#download lat glog version (Oct 20, 2016) to have CMake build system
set(CACHED_URL https://github.com/google/glog/archive/b6a5e0524c28178985f0d228e9eaa43808dbec3c.tar.gz)

set(GLOG_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DBUILD_TESTING:BOOL=OFF
                    -DWITH_GFLAGS:BOOL=OFF
                    -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -std=c++11
)

ExternalProject_Add(
        glog
        URL ${CACHED_URL}
        URL_HASH SHA256=41aa28e67340b27c12fae27a6a0949682283eac6c85e4d38671acf73d37cad88
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DOWNLOAD_NAME glog-0.3.4-rev-b6a5e05.tar.gz
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${GLOG_CMAKE_ARGS}
)
