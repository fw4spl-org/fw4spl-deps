cmake_minimum_required(VERSION 3.0)

project(freetypeBuilder)

include(ExternalProject)

set(CACHED_URL http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.1.tar.gz)


set(FREETYPE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(FREETYPE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        
)
ExternalProject_Add(
    freetype
    URL ${CACHED_URL}
    URL_HASH SHA256=8eec68b480bc7c1e2bce365f07f8c4cc29c1c238ac8737b8281c3895f5013cfc
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS zlib
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${FREETYPE_PATCH_DIR}/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREETYPE_CMAKE_ARGS}
)
