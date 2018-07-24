cmake_minimum_required(VERSION 3.0)

project(zlibBuilder)

include(ExternalProject)

set(CACHED_URL http://zlib.net/fossils/zlib-1.2.8.tar.gz)

set(ZLIB_CMAKE_ARGS ${COMMON_CMAKE_ARGS})
set(PATCH_CMD)
if(ANDROID)
    set(PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_CURRENT_SOURCE_DIR}/patch/android/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt")
endif()

ExternalProject_Add(
    zlib
    URL ${CACHED_URL}
    URL_HASH SHA256=36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ZLIB_CMAKE_ARGS}
)

if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
        set(ZLIB_LIB_NAME "zlibd")
    else()
       set(ZLIB_LIB_NAME "zlib")
    endif()
else()
    set(ZLIB_LIB_NAME "z")
endif()

set(ZLIB_LIB_NAME ${ZLIB_LIB_NAME} PARENT_SCOPE)

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC")
endif()

if(WIN32)
    # HACK: rename zlib because Qt searches for zdll.lib on windows.
    # This lib can be found through FindZlib so doing this shouldn't break other BinPkgs.
    set(RENAME_ZLIB_CMD ${CMAKE_COMMAND} -E rename "${ZLIB_LIB_NAME}.lib" zdll.lib)

    ExternalProject_Add_Step(zlib RENAME_ZLIB
        COMMAND ${RENAME_ZLIB_CMD}
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )
endif()
