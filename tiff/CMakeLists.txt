CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(tiffBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://download.osgeo.org/libtiff/tiff-4.0.3.zip CACHED_URL)

if(WIN32)
    SET(TIFF_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    SET(TIFF_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
    ExternalProject_Add(
        tiff
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS jpeg zlib
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${TIFF_PATCH_DIR}/" "<SOURCE_DIR>/"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${TIFF_CMAKE_ARGS}
    )
ELSE(WIN32)
    ExternalProject_Add(
        tiff
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        DEPENDS jpeg zlib
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                        --enable-shared
                        --disable-static
                        --enable-cxx
                        --with-zlib-lib-dir=${CMAKE_INSTALL_PREFIX}/lib
                        --with-zlib-include-dir=${CMAKE_INSTALL_PREFIX}/include
                        --with-jpeg-lib-dir=${CMAKE_INSTALL_PREFIX}/lib
                        --with-jpeg-include-dir=${CMAKE_INSTALL_PREFIX}/include
                        --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_tiff} install
    )

    ExternalProject_Add_Step(tiff COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_tiff} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )

ENDIF(WIN32)

