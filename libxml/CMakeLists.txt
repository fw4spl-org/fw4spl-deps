cmake_minimum_required(VERSION 2.8)

project(libxmlBuilder)

include(ExternalProject)


getCachedUrl(http://xmlsoft.org/sources/libxml2-2.9.1.tar.gz CACHED_URL)

set(LIBXML2_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

if(ANDROID)

    set(LIBXML2_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
        -DXML2_BUILD_SHARED=BOOL:ON
    )
    
    ExternalProject_Add(
        libxml
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS libiconv zlib
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${LIBXML2_PATCH_DIR}/android" "<SOURCE_DIR>/"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${LIBXML2_CMAKE_ARGS}
    )
    
elseif(WIN32)
    set(LIBXML2_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/libxml-prefix/src/libxml)
    
    file(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX} LIBXML_INSTALL_DIR_WIN32)
    #patch zlib name and prefix
    configure_file(${LIBXML2_PATCH_DIR}/Makefile.msvc.cmake
                   ${CMAKE_CURRENT_BINARY_DIR}/Makefile.msvc @ONLY
    )
    
    set(CONFIGURE_CMD cscript configure.js
                      zlib=yes iconv=yes compiler=msvc
                      prefix="${CMAKE_INSTALL_PREFIX}"
                      include=${CMAKE_INSTALL_PREFIX}/include
                      lib=${CMAKE_INSTALL_PREFIX}/lib
    )
    if(IS_DEBUG)
        set(CONFIGURE_CMD ${CONFIGURE_CMD} debug=yes cruntime=/MDd)
    else(IS_DEBUG)
        set(CONFIGURE_CMD ${CONFIGURE_CMD} debug=no cruntime=/MD)
    endif(IS_DEBUG)

    
    
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/libxml2_config.cmake
        "execute_process( COMMAND ${CONFIGURE_CMD} WORKING_DIRECTORY ${LIBXML2_SRC_DIR}/win32 )"
    )
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/libxml2_build.cmake 
        "execute_process( COMMAND nmake /f Makefile.msvc WORKING_DIRECTORY ${LIBXML2_SRC_DIR}/win32)"
    )
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/libxml2_install.cmake 
        "execute_process( COMMAND nmake /f Makefile.msvc install WORKING_DIRECTORY ${LIBXML2_SRC_DIR}/win32)"
    )
    
    set(LIBXML2_CONFIG_CMD ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/libxml2_config.cmake)
    set(LIBXML2_BUILD_CMD ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/libxml2_build.cmake)
    set(LIBXML2_INSTALL_CMD ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/libxml2_install.cmake)
      
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
    
else()
    set(CONFIGURE_CMD <SOURCE_DIR>/configure
                      --enable-shared --disable-static --without-libintl --enable-extra-encodings
                      # FIXME : Issue with zlib:
                      # "Undefined reference to `gzdirect@ZLIB_1.2.2.3'"
                      --with-zlib=${CMAKE_INSTALL_PREFIX}
                      #--without-zlib
                      --without-lzma
                      --without-python
                      --prefix=${CMAKE_INSTALL_PREFIX}
    )
    if(${IS_DEBUG})
        set(CONFIGURE_CMD ${CONFIGURE_CMD} --with-debug)
    else(${IS_DEBUG})
        set(CONFIGURE_CMD ${CONFIGURE_CMD} --without-debug)
    endif(${IS_DEBUG})

    if("${CMAKE_SYSTEM}" MATCHES "Linux")
        set(CONFIGURE_CMD ${CONFIGURE_CMD} --with-iconv=${CMAKE_INSTALL_PREFIX})
    endif()
    

    if(NOT APPLE)
        set(EXTRA_DEPENDS libiconv)
    endif()

    ExternalProject_Add(
        libxml
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS ${EXTRA_DEPENDS} zlib
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${CONFIGURE_CMD}
        BUILD_COMMAND ${MAKE}
        INSTALL_COMMAND ${MAKE} DESTDIR=${INSTALL_PREFIX_libxml} install
    )
    ExternalProject_Add_Step(libxml COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_libxml} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )

endif()
