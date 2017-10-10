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
        set(ZLIB_LIB_NAME "zlibd" PARENT_SCOPE)
    else()
        set(ZLIB_LIB_NAME "zlib" PARENT_SCOPE)
    endif()
else()
    set(ZLIB_LIB_NAME "z" PARENT_SCOPE)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC")
endif()

if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
        set(RENAME_ZLIB_CMD ${CMAKE_COMMAND} -E copy_if_different zlibd.lib zdll.lib
                            COMMAND ${CMAKE_COMMAND} -E copy_if_different zlibd.lib zlib.lib)
    else()
        set(RENAME_ZLIB_CMD ${CMAKE_COMMAND} -E copy_if_different zlib.lib zdll.lib)
    endif()

    ExternalProject_Add_Step(zlib RENAME_ZLIB
        COMMAND ${RENAME_ZLIB_CMD}
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )
endif()
