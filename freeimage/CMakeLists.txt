cmake_minimum_required(VERSION 3.0)

project(FreeImageBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/FreeImage/archive/FreeImage_3.16.0.c.tar.gz)

set(FREEIMAGE_HASHSUM 9f13ba99e176e97a39ea9387ec79bea52620114d4d37e673942b8cababf99ecb)

set(FREEIMAGE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DFREEIMAGE_BUILD_STATIC:BOOL=OFF
                        -DFREEIMAGE_USE_SYSTEM_ZLIB:BOOL=ON
                        -DFREEIMAGE_USE_SYSTEM_JPEG:BOOL=ON
                        -DFREEIMAGE_USE_SYSTEM_PNG:BOOL=ON
                        -DINSTALL_WRAPPER:BOOL=OFF
                        -DINSTALL_EXAMPLES:BOOL=OFF
)

if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(FREEIMAGE_DEPENDS libpng tiff jpeg)
endif()

ExternalProject_Add(
    freeimage
    URL ${CACHED_URL}
    URL_HASH SHA256=${FREEIMAGE_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS ${FREEIMAGE_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREEIMAGE_CMAKE_ARGS}
)


