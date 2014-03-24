CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(boostBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://freefr.dl.sourceforge.net/boost/boost_1_54_0.tar.gz CACHED_URL)

STRING(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
SET(BOOST_BUILD_TYPE debug)
IF(BUILD_TYPE MATCHES "release")
    SET(BOOST_BUILD_TYPE release)
ENDIF()

SET(BOOST_ARGS
    --prefix=${CMAKE_INSTALL_PREFIX}
    --exec-prefix=${CMAKE_INSTALL_PREFIX}/bin
    --libdir=${CMAKE_INSTALL_PREFIX}/lib
    --includedir=${CMAKE_INSTALL_PREFIX}/include
    -sZLIB_INCLUDE=${CMAKE_INSTALL_PREFIX}/include
    -sZLIB_LIBPATH=${CMAKE_INSTALL_PREFIX}/lib
    #-sZLIB_SOURCE=${CMAKE_INSTALL_PREFIX}
    -sNO_COMPRESSION=0
    -sNO_ZLIB=0
    -sNO_BZIP2=1
    --layout=versioned
    --build-type=minimal
    --without-test
    #--with-python=${CMAKE_INSTALL_PREFIX}
    variant=${BOOST_BUILD_TYPE}
    link=shared
    address-model=64
    threading=multi
)

SET(PYTHON_DIR ${CMAKE_INSTALL_PREFIX})
SET(PYTHON_INCLUDE ${PYTHON_DIR}/include/python2.7)


set(BOOST_USER_CONFIG)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set( BOOST_USER_CONFIG "using clang : : ${CMAKE_CXX_COMPILER} ;")
  list(APPEND BOOST_ARGS toolset=clang)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    if(APPLE AND ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS "4.3")
    message(
        WARNING 
        "boost current build configuration will fail with gcc ${CMAKE_CXX_COMPILER_VERSION}"
        " on Mac OSX. Skipping boost...")
    return()

    endif()

#  # using GCC
#elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
#  # using Intel C++
#elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
#  # using Visual Studio C++
endif()

IF(NOT WIN32)
    list(APPEND BOOST_ARGS cxxflags=-ftemplate-depth=256)
ENDIF()


IF(${IS_DEBUG})
    SET(BOOST_ARGS ${BOOST_ARGS} python-debugging=on)
    SET(PYTHON_DEBUGGING "<python-debugging>on")
ENDIF()

IF(WIN32)
    SET(BOOTSTRAP_CMD ./bootstrap.bat)
    #ZLIB_LIB_NAME is defined in zlib BinPkgs script
    SET(BOOST_ARGS 
        ${BOOST_ARGS}
        --abbreviate-paths
        --without-mpi
        --toolset=msvc-10.0
        architecture=x86
        -sZLIB_BINARY=${ZLIB_LIB_NAME}
    )
ELSE(WIN32)
    SET(BOOTSTRAP_CMD bash
                      bootstrap.sh
                      --with-icu=${CMAKE_INSTALL_PREFIX}
                      --with-python=${CMAKE_INSTALL_PREFIX}
    )
ENDIF(WIN32)

SET(BOOST_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
CONFIGURE_FILE(${BOOST_PATCH_DIR}/user-config.jam.cmake 
               ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam @ONLY
)

IF(WIN32)
    SET(BOOST_MOVE_LIB_DIR ${CMAKE_INSTALL_PREFIX}/lib/)
    SET(BOOST_MOVE_BIN_DIR ${CMAKE_INSTALL_PREFIX}/bin/)
    FILE(TO_NATIVE_PATH ${BOOST_MOVE_LIB_DIR}  BOOST_MOVE_LIB_DIR)
    FILE(TO_NATIVE_PATH ${BOOST_MOVE_BIN_DIR}  BOOST_MOVE_BIN_DIR)
    SET(BOOST_MOVE_DLL_CMD ${CMAKE_COMMAND} -E comspec "cmd /C move /Y ${BOOST_MOVE_LIB_DIR}*.dll ${BOOST_MOVE_BIN_DIR}")
ELSE(WIN32)
    SET(BOOST_MOVE_DLL_CMD ${CMAKE_COMMAND} -E echo "Nothing to do")
ENDIF(WIN32)

IF(NOT APPLE)
    SET(EXTRA_DEPENDS libiconv)
ENDIF()

ExternalProject_Add(
    boost
    DEPENDS zlib python ${EXTRA_DEPENDS}
    URL ${CACHED_URL}
    URL_MD5 efbfbff5a85a9330951f243d0a46e4b9
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam <SOURCE_DIR>/user-config.jam
    CONFIGURE_COMMAND ${BOOTSTRAP_CMD}
    BUILD_COMMAND <SOURCE_DIR>/b2 -j${NUMBER_OF_PARALLEL_BUILD} ${BOOST_ARGS} -sHOME=<SOURCE_DIR> install
    INSTALL_COMMAND ${BOOST_MOVE_DLL_CMD}
)
