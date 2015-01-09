cmake_minimum_required(VERSION 2.8)

project(tiffBuilder)

include(ExternalProject)

getCachedUrl(http://download.osgeo.org/libtiff/tiff-4.0.3.zip CACHED_URL)

if(WIN32 OR ANDROID)
    
    set(TIFF_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    
    set(TIFF_PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${TIFF_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/")
    
    if(ANDROID)
        list(APPEND TIFF_PATCH_COMMAND
                COMMAND ${CMAKE_COMMAND} -E copy_if_different "${TIFF_PATCH_DIR}/tif_config.vc.h" "<SOURCE_DIR>/libtiff"
                COMMAND ${CMAKE_COMMAND} -E copy_if_different "${TIFF_PATCH_DIR}/tiffconf.vc.h" "<SOURCE_DIR>/libtiff" 
            )
    endif()
             
    set(TIFF_CMAKE_ARGS ${COMMON_CMAKE_ARGS})
       
    ExternalProject_Add(
        tiff
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS jpeg zlib
        PATCH_COMMAND ${TIFF_PATCH_COMMAND}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${TIFF_CMAKE_ARGS}
    )
    
else()
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

endif()

