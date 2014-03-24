CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(icu4cBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-src.tgz CACHED_URL)

IF(WIN32)

    SET(ICU4C_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    SET(ICU4C_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                         -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    )
    ExternalProject_Add(
        icu4c
        URL ${CACHED_URL}
        URL_MD5 072e501b87065f3a0ca888f1b5165709
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${ICU4C_PATCH_DIR}/" "<SOURCE_DIR>"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${ICU4C_CMAKE_ARGS}
    )
ELSE(WIN32)
    ExternalProject_Add(
        icu4c
        URL ${CACHED_URL}
        URL_MD5 072e501b87065f3a0ca888f1b5165709
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/source ./configure
                        --enable-shared
                        --disable-static
                        --prefix=${CMAKE_INSTALL_PREFIX}
        #BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/source/Makefile
        #INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/source/Makefile install
        BUILD_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/source ${MAKE}
        INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/source ${MAKE} install
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    )
ENDIF(WIN32)
