CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(freetypeBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.1.tar.gz CACHED_URL)

IF(WIN32)

    SET(FREETYPE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    SET(FREETYPE_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                            -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
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
ELSE(WIN32)
    #set path for zlib and png
    SET(SETENV export PATH=${CMAKE_INSTALL_PREFIX}/bin:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/include:$ENV{PATH} )   

    ExternalProject_Add(
        freetype
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        DEPENDS zlib libpng
        CONFIGURE_COMMAND ${SETENV} &&  <SOURCE_DIR>/configure
                        --enable-shared
                        --disable-static
                        --prefix=${CMAKE_INSTALL_PREFIX}

        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_freetype} install
    )
    ExternalProject_Add_Step(freetype COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_freetype} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
ENDIF(WIN32)

