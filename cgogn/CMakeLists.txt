cmake_minimum_required(VERSION 3.1)

project(cgognBuilder)

INCLUDE(ExternalProject)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(CGOGN_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DDISABLE_AUTO_LINK=ON
                        -DBoost_DEBUG=OFF
                        -DBoost_NO_SYSTEM_PATHS=ON
                        -DBoost_USE_DEBUG_PYTHON=ON
                        -DBoost_USE_MULTITHREADED=ON
                        -DBoost_COMPILER:STRING=${Boost_COMPILER}
                        -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}
)

set(CGOGN_VERSION 2017-11)
set(CACHED_URL https://github.com/fw4spl-org/cgogn-light/archive/${CGOGN_VERSION}.tar.gz )

if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(CGOGN_DEPENDS libxml zlib)
endif()

ExternalProject_Add(
    cgogn
    URL ${CACHED_URL}
    URL_HASH SHA256=2d128823934f2c242e74b6f88d9303a4ade5ca5157ea84425e588b9ddae3d2f6
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME cgogn-light-${CGOGN_VERSION}.zip
    DEPENDS ${CGOGN_DEPENDS} boost eigen
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CGOGN_CMAKE_ARGS}
)
