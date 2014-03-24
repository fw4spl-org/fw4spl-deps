CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(libiconvBuilder)

INCLUDE(ExternalProject)

IF(WIN32)
    GET_CACHED_URL(https://win-iconv.googlecode.com/files/win-iconv-0.0.6.tar.bz2 CACHED_URL)

    SET(LIBICONV_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${LIBICONV_CMAKE_ARGS}
    )
ELSE()
    SET(LIBICONV_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    GET_CACHED_URL(http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz CACHED_URL)

    IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        SET(LIBICONV_PATCH_CMD && patch -t -N -p1 < ${LIBICONV_PATCH_DIR}/linux-remove-gets.patch )
    ENDIF()

    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                          --enable-shared
                          --disable-static
                          --without-libintl
                          --enable-extra-encodings
                          --prefix=${CMAKE_INSTALL_PREFIX}
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory "${LIBICONV_PATCH_DIR}/" "<SOURCE_DIR>/" ${LIBICONV_PATCH_CMD}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile install
    )
ENDIF()
