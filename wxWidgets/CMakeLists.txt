cmake_minimum_required(VERSION 2.8)

project(wxWidgetsBuilder)

include(ExternalProject)

getCachedUrl(http://freefr.dl.sourceforge.net/wxwindows/wxWidgets-2.9.5.tar.bz2 CACHED_URL)

set(WX_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

if(WIN32)
    if(IS_DEBUG)
        set(BUILDTYPE "debug")
    else()
        set(BUILDTYPE "release")
    endif()
    set(BUILD_CMD
        -f 
        ${CMAKE_CURRENT_BINARY_DIR}/makefile.vc
        BUILD=${BUILDTYPE}
        UNICODE=1
        SHARED=1
        MONOLITHIC=0
        USE_GUI=1
        USE_HTML=1
        USE_WEBVIEW=1
        USE_MEDIA=1
        USE_XRC=1
        USE_AUI=1
        USE_RIBBON=1
        USE_PROPGRID=1
        USE_RICHTEXT=1
        USE_STC=1
        USE_OPENGL=1
        USE_QA=1
        USE_EXCEPTIONS=1
        USE_RTTI=1
        USE_THREADS=1
        USE_CAIRO=0
    )

    set(INCLUDE_ZLIB  ${CMAKE_INSTALL_PREFIX}/include)
    set(INCLUDE_EXPAT ${CMAKE_INSTALL_PREFIX}/include)
    set(INCLUDE_PNG   ${CMAKE_INSTALL_PREFIX}/include)
    set(INCLUDE_JPEG  ${CMAKE_INSTALL_PREFIX}/include)
    set(INCLUDE_TIFF  ${CMAKE_INSTALL_PREFIX}/include)
    
    set(LIB_ZLIB  ${CMAKE_INSTALL_PREFIX}/lib/zlib.lib)
    set(LIB_EXPAT ${CMAKE_INSTALL_PREFIX}/lib/expat.lib)
    set(LIB_PNG   ${CMAKE_INSTALL_PREFIX}/lib/png.lib)
    set(LIB_JPEG  ${CMAKE_INSTALL_PREFIX}/lib/jpeg.lib)
    set(LIB_TIFF  ${CMAKE_INSTALL_PREFIX}/lib/libtiff.lib)
    
    set(WX_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/wxWidgets-prefix/src/wxWidgets)
    configure_file(${WX_PATCH_DIR}/makefile.vc.in 
                   ${CMAKE_CURRENT_BINARY_DIR}/makefile.vc @ONLY
                   )
                   
    set(WX_DEBUG_FLAG)
    if(IS_DEBUG)
        set(WX_DEBUG_FLAG "d")
    endif(IS_DEBUG)
    string(REGEX REPLACE "/" "\\\\" WX_SRC_WINDIR ${WX_SRC_DIR})
    string(REGEX REPLACE "/" "\\\\" WX_INSTALL_WINDIR ${CMAKE_INSTALL_PREFIX})
    
    configure_file(${WX_PATCH_DIR}/install.bat.in
                   ${CMAKE_CURRENT_BINARY_DIR}/install.bat @ONLY
                   )
                   
    ExternalProject_Add(
        wxWidgets
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS zlib jpeg libpng tiff expat
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${WX_PATCH_DIR}/include" "<SOURCE_DIR>/include"
        CONFIGURE_COMMAND ""
        BINARY_DIR ${WX_SRC_DIR}/build/msw/
        BUILD_COMMAND ${MAKE} ${BUILD_CMD}
        INSTALL_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/install.bat
        STEP_TARGETS CopyConfigFileToInstall
    )

else(WIN32)
    set(WX_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/wxWidgets-prefix/src/wxWidgets)
    set(WX_CONFIGURE
            ${WX_SRC_DIR}/configure
            --enable-shared
            --disable-static
            --enable-unicode
            --with-opengl
            --with-libjpeg=sys
            --with-libpng=sys
            --with-libtiff=sys
            --with-zlib=sys
            --with-expat=sys
            --disable-samples
            --without-subdirs
            --prefix=${CMAKE_INSTALL_PREFIX}
    )
    ExternalProject_Add(
        wxWidgets
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS zlib jpeg libpng tiff expat freetype libiconv
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${WX_PATCH_DIR}/include" "<SOURCE_DIR>/include"
        CONFIGURE_COMMAND ${WX_CONFIGURE}
        BUILD_IN_SOURCE 1
        BUILD_COMMAND ${MAKE} install
        INSTALL_COMMAND ""
        STEP_TARGETS CopyConfigFileToInstall
    )
endif(WIN32)

ExternalProject_Add_Step(wxWidgets CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-wxWidgets.cmake ${CMAKE_INSTALL_PREFIX}/fw-wxWidgets.cmake
    COMMENT "Install configuration file"
)
