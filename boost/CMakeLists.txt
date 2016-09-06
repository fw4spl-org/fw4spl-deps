cmake_minimum_required(VERSION 3.0)

project(boostBuilder)

include(ExternalProject)

set(CACHED_URL http://freefr.dl.sourceforge.net/boost/boost_1_61_0.tar.gz)
set(BOOST_HASHSUM a77c7cc660ec02704c6884fbb20c552d52d60a18f26573c9cee0788bf00ed7e6)

string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
set(BOOST_BUILD_TYPE debug)
if(BUILD_TYPE MATCHES "release")
    set(BOOST_BUILD_TYPE release)
endif()

if(WIN32)
    set(PYTHON_DIR ${CMAKE_INSTALL_PREFIX}/Python-3.5.2)
    set(PYTHON_BIN ${PYTHON_DIR})
    set(PYTHON_INCLUDE ${PYTHON_DIR}/include)
    set(PYTHON_LIB ${PYTHON_DIR}/libs)
else()
    set(PYTHON_DIR ${CMAKE_INSTALL_PREFIX})
    set(PYTHON_BIN ${PYTHON_DIR}/bin)
    if(${IS_DEBUG})
        set(PYTHON_INCLUDE ${PYTHON_DIR}/include/python3.5dm)
    else()
        set(PYTHON_INCLUDE ${PYTHON_DIR}/include/python3.5m)
    endif()
    set(PYTHON_LIB ${PYTHON_DIR}/lib)
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
