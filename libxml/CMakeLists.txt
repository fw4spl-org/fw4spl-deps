CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(libxmlBuilder)

INCLUDE(ExternalProject)


GET_CACHED_URL(http://xmlsoft.org/sources/libxml2-2.9.1.tar.gz CACHED_URL)

IF(WIN32)
    SET(LIBXML2_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    SET(LIBXML2_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/libxml-prefix/src/libxml)
    
    FILE(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX} LIBXML_INSTALL_DIR_WIN32)
    #patch zlib name and prefix
    CONFIGURE_FILE(${LIBXML2_PATCH_DIR}/Makefile.msvc.cmake
                   ${CMAKE_CURRENT_BINARY_DIR}/Makefile.msvc @ONLY
    )
    
    SET(CONFIGURE_CMD cscript configure.js
                      zlib=yes iconv=yes compiler=msvc
                      prefix="${CMAKE_INSTALL_PREFIX}"
                      include=${CMAKE_INSTALL_PREFIX}/include
                      lib=${CMAKE_INSTALL_PREFIX}/lib
    )
    IF(IS_DEBUG)
        SET(CONFIGURE_CMD ${CONFIGURE_CMD} debug=yes cruntime=/MDd)
    ELSE(IS_DEBUG)
        SET(CONFIGURE_CMD ${CONFIGURE_CMD} debug=no cruntime=/MD)
    ENDIF(IS_DEBUG)

    
    
    FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/libxml2_config.cmake
        "execute_process( COMMAND ${CONFIGURE_CMD} WORKING_DIRECTORY ${LIBXML2_SRC_DIR}/win32 )"
    )
    FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/libxml2_build.cmake 
        "execute_process( COMMAND nmake /f Makefile.msvc WORKING_DIRECTORY ${LIBXML2_SRC_DIR}/win32)"
    )
    FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/libxml2_install.cmake 
        "execute_process( COMMAND nmake /f Makefile.msvc install WORKING_DIRECTORY ${LIBXML2_SRC_DIR}/win32)"
    )
    
    SET(LIBXML2_CONFIG_CMD ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/libxml2_config.cmake)
    SET(LIBXML2_BUILD_CMD ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/libxml2_build.cmake)
    SET(LIBXML2_INSTALL_CMD ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/libxml2_install.cmake)
      
    ExternalProject_Add(
        libxml
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS libiconv zlib
        BUILD_IN_SOURCE 1
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/Makefile.msvc <SOURCE_DIR>/win32/Makefile.msvc
        CONFIGURE_COMMAND ${LIBXML2_CONFIG_CMD}
        BUILD_COMMAND ${LIBXML2_BUILD_CMD}
        INSTALL_COMMAND ${LIBXML2_INSTALL_CMD}
    )
ELSE(WIN32)
    SET(CONFIGURE_CMD <SOURCE_DIR>/configure
                      --enable-shared --disable-static --without-libintl --enable-extra-encodings
                      # FIXME : Issue with zlib:
                      # "Undefined reference to `gzdirect@ZLIB_1.2.2.3'"
                      --with-zlib=${CMAKE_INSTALL_PREFIX}
                      #--without-zlib
                      --without-lzma
                      --without-python
                      --prefix=${CMAKE_INSTALL_PREFIX}
    )
    IF(${IS_DEBUG})
        SET(CONFIGURE_CMD ${CONFIGURE_CMD} --with-debug)
    ELSE(${IS_DEBUG})
        SET(CONFIGURE_CMD ${CONFIGURE_CMD} --without-debug)
    ENDIF(${IS_DEBUG})

    IF("${CMAKE_SYSTEM}" MATCHES "Linux")
        SET(CONFIGURE_CMD ${CONFIGURE_CMD} --with-iconv=${CMAKE_INSTALL_PREFIX})
    ENDIF()
    

    IF(NOT APPLE)
        SET(EXTRA_DEPENDS libiconv)
    ENDIF()

    ExternalProject_Add(
        libxml
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS ${EXTRA_DEPENDS} zlib
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${CONFIGURE_CMD}
        BUILD_COMMAND ${MAKE}
        INSTALL_COMMAND ${MAKE} install
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    )

ENDIF(WIN32)
