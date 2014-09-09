cmake_minimum_required(VERSION 2.8)

project(boostBuilder)

include(ExternalProject)

getCachedUrl(http://freefr.dl.sourceforge.net/boost/boost_1_54_0.tar.gz CACHED_URL)

string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
set(BOOST_BUILD_TYPE debug)
if(BUILD_TYPE MATCHES "release")
    set(BOOST_BUILD_TYPE release)
endif()

if(NOT WIN32)
    set(BOOST_ARGS 
        --prefix=${INSTALL_PREFIX_boost}/${CMAKE_INSTALL_PREFIX})
else()
    set(BOOST_ARGS
        --prefix=${CMAKE_INSTALL_PREFIX}
        --libdir=${CMAKE_INSTALL_PREFIX}/lib
        --includedir=${CMAKE_INSTALL_PREFIX}/include)
endif()

set(BOOST_ARGS
    ${BOOST_ARGS}
    --exec-prefix=${CMAKE_INSTALL_PREFIX}/bin
    -sZLIB_INCLUDE=${CMAKE_INSTALL_PREFIX}/include
    -sZLIB_LIBPATH=${CMAKE_INSTALL_PREFIX}/lib
    #-sZLIB_SOURCE=${CMAKE_INSTALL_PREFIX}
    -sNO_COMPRESSION=0
    -sNO_ZLIB=0
    -sNO_BZIP2=1
    --layout=versioned
    --build-type=minimal
    --without-test
    variant=${BOOST_BUILD_TYPE}
    link=shared
    address-model=64
    threading=multi
)

set(PYTHON_DIR ${CMAKE_INSTALL_PREFIX})
set(PYTHON_INCLUDE ${PYTHON_DIR}/include/python2.7)


set(BOOST_USER_CONFIG)

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set( BOOST_USER_CONFIG "using clang : : ${CMAKE_CXX_COMPILER} ;")
  list(APPEND BOOST_ARGS toolset=clang)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    if(APPLE AND ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS "4.3")
    message(
        WARNING 
        "boost current build configuration will fail with gcc ${CMAKE_CXX_COMPILER_VERSION}"
        " on Mac OSX. Skipping boost...")
    return()

    endif()

#  # using GCC
#elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
#  # using Intel C++
#elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
#  # using Visual Studio C++
endif()

if(NOT WIN32)
    list(APPEND BOOST_ARGS cxxflags=-ftemplate-depth=256)
endif()


if(${IS_DEBUG})
    set(BOOST_ARGS ${BOOST_ARGS} python-debugging=on)
    set(PYTHON_DEBUGGING "<python-debugging>on")
endif()

if(WIN32)
    set(BOOTSTRAP_CMD ./bootstrap.bat)
    #ZLIB_LIB_NAME is defined in zlib BinPkgs script
    set(BOOST_ARGS 
        ${BOOST_ARGS}
        --abbreviate-paths
        --without-mpi
        --toolset=msvc-10.0
        architecture=x86
        -sZLIB_BINARY=${ZLIB_LIB_NAME}
    )
else(WIN32)
    set(BOOTSTRAP_CMD bash
                      bootstrap.sh
                      --with-icu=${CMAKE_INSTALL_PREFIX}
                      --with-python-root=${CMAKE_INSTALL_PREFIX}
    )
endif(WIN32)

if(NOT APPLE)
    set(BOOST_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    configure_file(${BOOST_PATCH_DIR}/user-config.jam.cmake 
                  ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam @ONLY
          )
endif()

if(WIN32)
    set(BOOST_MOVE_LIB_DIR ${CMAKE_INSTALL_PREFIX}/lib/)
    set(BOOST_MOVE_BIN_DIR ${CMAKE_INSTALL_PREFIX}/bin/)
    file(TO_NATIVE_PATH ${BOOST_MOVE_LIB_DIR}  BOOST_MOVE_LIB_DIR)
    file(TO_NATIVE_PATH ${BOOST_MOVE_BIN_DIR}  BOOST_MOVE_BIN_DIR)
    set(BOOST_MOVE_DLL_CMD ${CMAKE_COMMAND} -E comspec "cmd /C move /Y ${BOOST_MOVE_LIB_DIR}*.dll ${BOOST_MOVE_BIN_DIR}")
else(WIN32)
    set(BOOST_MOVE_DLL_CMD ${CMAKE_COMMAND} -E echo "Nothing to do")
endif(WIN32)

if(NOT APPLE)
    set(EXTRA_DEPENDS libiconv)
    set(PATCH_CMD ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_BINARY_DIR}/user-config.jam" "<SOURCE_DIR>/user-config.jam")
else(NOT APPLE)
    set(PATCH_CMD)
endif(NOT APPLE)

if(UNIX)
    set(SETENV export PATH=${CMAKE_INSTALL_PREFIX}/bin:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/include:$ENV{PATH} &&)  
endif()

ExternalProject_Add(
    boost
    DEPENDS zlib python ${EXTRA_DEPENDS}
    URL ${CACHED_URL}
    URL_MD5 efbfbff5a85a9330951f243d0a46e4b9
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${PATCH_CMD}
    CONFIGURE_COMMAND ${SETENV} ${BOOTSTRAP_CMD}
    STEP_TARGETS CopyConfigFileToInstall
    BUILD_COMMAND ${SETENV} <SOURCE_DIR>/b2 -j${NUMBER_OF_PARALLEL_BUILD} ${BOOST_ARGS} -sHOME=<SOURCE_DIR> install
    INSTALL_COMMAND ${BOOST_MOVE_DLL_CMD}
)

if(NOT WIN32)
    ExternalProject_Add_Step(boost COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_boost} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
endif()

ExternalProject_Add_Step(boost CopyConfigFileToInstall
    COMMAND  ${CMAKE_COMMAND} -E copy  ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake ${CMAKE_INSTALL_PREFIX}/fw-boost.cmake
    COMMENT "Install configuration file"
)
