cmake_minimum_required(VERSION 3.0)

project(boostBuilder)

include(ExternalProject)

set(CACHED_URL https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2)
set(BOOST_HASHSUM 2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba)

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    set(BOOST_BUILD_TYPE debug)
    set(BOOST_DEBUG_SYMBOLS on)
    set(BOOST_OPTIMIZATION off)
elseif(${CMAKE_BUILD_TYPE} STREQUAL "Release")
    set(BOOST_BUILD_TYPE release)
    set(BOOST_DEBUG_SYMBOLS off)
    set(BOOST_OPTIMIZATION speed)
elseif(${CMAKE_BUILD_TYPE} STREQUAL "RelWithDebInfo")
    set(BOOST_BUILD_TYPE release)
    set(BOOST_DEBUG_SYMBOLS on)
    set(BOOST_OPTIMIZATION speed)
elseif(${CMAKE_BUILD_TYPE} STREQUAL "MinSizeRel")
    set(BOOST_BUILD_TYPE release)
    set(BOOST_DEBUG_SYMBOLS off)
    set(BOOST_OPTIMIZATION space)
endif()

set(BOOST_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

math(EXPR BITS "8*${CMAKE_SIZEOF_VOID_P}")
set(BOOST_ARGS
    --exec-prefix=${CMAKE_INSTALL_PREFIX}/bin
    -sZLIB_INCLUDE=${CMAKE_INSTALL_PREFIX}/include
    -sZLIB_LIBPATH=${CMAKE_INSTALL_PREFIX}/lib
    -sNO_COMPRESSION=0
    -sNO_ZLIB=0
    -sNO_BZIP2=1
    --layout=system
    --build-type=minimal
    --without-test
    --without-python
    variant=${BOOST_BUILD_TYPE}
    debug-symbols=${BOOST_DEBUG_SYMBOLS}
    optimization=${BOOST_OPTIMIZATION}
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

fwInstallFile(
    BINPKG boost
    SRC ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/fw-boost.cmake
)
