CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(freetypeBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.1.tar.gz CACHED_URL)

IF(WIN32)

    SET(FREETYPE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    SET(FREETYPE_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
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
ELSE()
    #@TODO: need zlib?
    set(EXTRA_OPT --without-png)
    ExternalProject_Add(
        freetype
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        DEPENDS zlib
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                        --enable-shared
                        --disable-static
                        ${EXTRA_OPT}
                        --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile install
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    )
ENDIF()
