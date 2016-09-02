cmake_minimum_required(VERSION 3.0)

project(boostBuilder)

include(ExternalProject)

set(CACHED_URL http://freefr.dl.sourceforge.net/boost/boost_1_57_0.tar.gz)

string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
set(BOOST_BUILD_TYPE debug)
if(BUILD_TYPE MATCHES "release")
    set(BOOST_BUILD_TYPE release)
endif()

set(PYTHON_DIR ${CMAKE_INSTALL_PREFIX})
set(PYTHON_INCLUDE ${PYTHON_DIR}/include/python2.7)
set(BOOST_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

math(EXPR BITS "8*${CMAKE_SIZEOF_VOID_P}")
set(BOOST_ARGS
    --exec-prefix=${CMAKE_INSTALL_PREFIX}/bin
    -sZLIB_INCLUDE=${CMAKE_INSTALL_PREFIX}/include
    -sZLIB_LIBPATH=${CMAKE_INSTALL_PREFIX}/lib
    -sNO_COMPRESSION=0
    -sNO_ZLIB=0
    -sNO_BZIP2=1
    --layout=versioned
    --build-type=minimal
    --without-test
    variant=${BOOST_BUILD_TYPE}
    link=shared
    address-model=${BITS}
    threading=multi
)

if(ANDROID)
    include(boost_android.cmake)
elseif(WIN32)
    include(boost_windows.cmake)
elseif(APPLE)
    include(boost_apple.cmake)
elseif(UNIX)
    include(boost_linux.cmake)
else()
    message(SEND_ERROR "Unknown plateform.")
endif()

ExternalProject_Add_Step(boost CopyConfigFileToInstall
    COMMAND  ${CMAKE_COMMAND} -E copy  ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake ${CMAKE_INSTALL_PREFIX}/fw-boost.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
