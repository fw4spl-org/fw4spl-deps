CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(jpegBuilder)

INCLUDE(ExternalProject)

SET(JPEG_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
SET(JPEG_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})

GET_CACHED_URL(http://www.ijg.org/files/jpegsrc.v8d.tar.gz CACHED_URL)

IF(WIN32)
    ExternalProject_Add(
        jpeg
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${JPEG_PATCH_DIR}/" "<SOURCE_DIR>/"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${JPEG_CMAKE_ARGS}
    )
    ExternalProject_Add_Step(jpeg RENAME_LIBJPEG
        COMMAND ${CMAKE_COMMAND} -E copy_if_different jpeg.lib libjpeg.lib
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
    )
ELSE()
    ExternalProject_Add(
        jpeg
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                        --enable-shared
                        --disable-static
                        --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile install
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    )
ENDIF()

IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fPIC")
ENDIF()
