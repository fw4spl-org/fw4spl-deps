cmake_minimum_required(VERSION 3.0)

project(pngBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/glennrp/libpng/archive/v1.6.21.tar.gz)
set(PNG_CMAKE_ARGS  ${COMMON_CMAKE_ARGS}
                    -DPNG_DEBUG:BOOL=OFF
                    -DPNG_SHARED:BOOL=ON
                    -DPNG_TESTS:BOOL=OFF
)
if(ANDROID)
    list(APPEND PNG_CMAKE_ARGS -DNO_SYMLINK:BOOL=ON)
endif()
set(LIBPNG_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/CMakeLists.txt.diff -d <SOURCE_DIR>)

ExternalProject_Add(
        libpng
        DEPENDS zlib
        URL ${CACHED_URL}
        URL_HASH SHA256=caa0f62d09452bf3018a7e22973246f62b5818c7bf86c466009ab11a68f0a137
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${LIBPNG_PATCH_CMD}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${PNG_CMAKE_ARGS}
)

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    set(LIBPNG_LIB_NAME "libpng16d")
else()
    set(LIBPNG_LIB_NAME "libpng16")
endif()
set(LIBPNG_LIB_NAME ${LIBPNG_LIB_NAME} PARENT_SCOPE)

if(WIN32)
    ExternalProject_Add_Step(libpng RENAME_LIBPNG
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBPNG_LIB_NAME}.lib libpng.lib
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBPNG_LIB_NAME}.lib png.lib
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )
endif()
