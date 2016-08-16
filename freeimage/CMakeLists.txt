cmake_minimum_required(VERSION 3.0)

project(FreeImageBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/greenjava/FreeImage/archive/FreeImage_3.16.0.b.tar.gz)

set(FREEIMAGE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DFREEIMAGE_BUILD_STATIC:BOOL=OFF
                        -DFREEIMAGE_USE_SYSTEM_ZLIB:BOOL=ON
                        -DFREEIMAGE_USE_SYSTEM_JPEG:BOOL=ON
                        -DFREEIMAGE_USE_SYSTEM_PNG:BOOL=ON
                        -DINSTALL_WRAPPER:BOOL=OFF
                        -DINSTALL_EXAMPLES:BOOL=OFF
)

#Patch FreeImage library to suppport C++11. (std::min/std::max now in algorithm header).
set(FREEIMAGE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch/OpenEXR)

ExternalProject_Add(
    freeimage
    URL ${CACHED_URL}
    URL_HASH SHA256=737a92c42b255cdc457c5d8b88cf8d6dc13a196fd74c4ac83c202e4b030419a5
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS zlib libpng tiff jpeg
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${FREEIMAGE_PATCH_DIR}/" "<SOURCE_DIR>/Source/OpenEXR/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREEIMAGE_CMAKE_ARGS}
)


