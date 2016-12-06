cmake_minimum_required(VERSION 3.0)

project(FreeImageBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/FreeImage/archive/FreeImage_3.16.0.c.tar.gz)

set(FREEIMAGE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DFREEIMAGE_BUILD_STATIC:BOOL=OFF
                        -DFREEIMAGE_USE_SYSTEM_TIFF:BOOL=ON
                        -DFREEIMAGE_USE_SYSTEM_ZLIB:BOOL=ON
                        -DFREEIMAGE_USE_SYSTEM_PNG:BOOL=ON
                        -DINSTALL_WRAPPER:BOOL=OFF
                        -DINSTALL_EXAMPLES:BOOL=OFF
)

if(ANDROID)
    set(PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/swab.h <SOURCE_DIR>/Source/LibRawLite/internal/swab.h
        COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/android.diff -d <SOURCE_DIR>
    )
    list(APPEND FREEIMAGE_CMAKE_ARGS
               -DFREEIMAGE_USE_SYSTEM_JPEG:BOOL=OFF)
else()
    list(APPEND FREEIMAGE_CMAKE_ARGS
               -DFREEIMAGE_USE_SYSTEM_JPEG:BOOL=ON)
endif()

ExternalProject_Add(
    freeimage
    URL ${CACHED_URL}
    URL_HASH SHA256=1a9c1854f434e4c301b5af94b6b64ea586c0e49944b57de4f1d8daca6cd560bc
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS zlib libpng tiff jpeg
    PATCH_COMMAND ${PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREEIMAGE_CMAKE_ARGS}
)


