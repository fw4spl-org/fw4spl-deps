cmake_minimum_required(VERSION 3.0)

project(tiffBuilder)

include(ExternalProject)

set(CACHED_URL ftp://download.osgeo.org/libtiff/old/tiff-4.0.3.zip)
set(TIFF_HASHSUM dd70349cedb3981371686e1c9b89a7f9)

if(WIN32 OR ANDROID)
    
    set(TIFF_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    
    set(TIFF_PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${TIFF_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/")
    
    if(ANDROID)
        list(APPEND TIFF_PATCH_COMMAND
                COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/tif_config.vc.h.droid.diff -d <SOURCE_DIR>
                COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/tiffconf.vc.h.droid.diff -d <SOURCE_DIR>
            )
    else()
        list(APPEND TIFF_PATCH_COMMAND
                COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/tif_config.vc.h.win32.diff -d <SOURCE_DIR>
            )
    endif()
             
    set(TIFF_CMAKE_ARGS ${COMMON_CMAKE_ARGS})
       
    ExternalProject_Add(
        tiff
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        URL_HASH MD5=${TIFF_HASHSUM}
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
        URL_HASH MD5=${TIFF_HASHSUM}
        BUILD_IN_SOURCE 1
        DEPENDS jpeg zlib
        CONFIGURE_COMMAND ${SET_COMPILER_ENV} <SOURCE_DIR>/configure
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
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_tiff} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )

endif()

