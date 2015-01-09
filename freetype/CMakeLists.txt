cmake_minimum_required(VERSION 2.8)

project(freetypeBuilder)

include(ExternalProject)

getCachedUrl(http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.1.tar.gz CACHED_URL)


set(FREETYPE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(FREETYPE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        
)
ExternalProject_Add(
    freetype
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS zlib
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${FREETYPE_PATCH_DIR}/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREETYPE_CMAKE_ARGS}
)
