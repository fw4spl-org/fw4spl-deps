CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(wxWidgetsBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://freefr.dl.sourceforge.net/wxwindows/wxWidgets-2.9.5.tar.bz2 CACHED_URL)

SET(WX_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

IF(WIN32)
    IF(IS_DEBUG)
        SET(BUILDTYPE "debug")
    ELSE()
        SET(BUILDTYPE "release")
    ENDIF()
    SET(BUILD_CMD
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

    SET(INCLUDE_ZLIB  ${CMAKE_INSTALL_PREFIX}/include)
    SET(INCLUDE_EXPAT ${CMAKE_INSTALL_PREFIX}/include)
    SET(INCLUDE_PNG   ${CMAKE_INSTALL_PREFIX}/include)
    SET(INCLUDE_JPEG  ${CMAKE_INSTALL_PREFIX}/include)
    SET(INCLUDE_TIFF  ${CMAKE_INSTALL_PREFIX}/include)
    
    SET(LIB_ZLIB  ${CMAKE_INSTALL_PREFIX}/lib/zlib.lib)
    SET(LIB_EXPAT ${CMAKE_INSTALL_PREFIX}/lib/expat.lib)
    SET(LIB_PNG   ${CMAKE_INSTALL_PREFIX}/lib/png.lib)
    SET(LIB_JPEG  ${CMAKE_INSTALL_PREFIX}/lib/jpeg.lib)
    SET(LIB_TIFF  ${CMAKE_INSTALL_PREFIX}/lib/libtiff.lib)
    
    SET(WX_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/wxWidgets-prefix/src/wxWidgets)
    CONFIGURE_FILE(${WX_PATCH_DIR}/makefile.vc.in 
                   ${CMAKE_CURRENT_BINARY_DIR}/makefile.vc @ONLY
                   )
                   
    SET(WX_DEBUG_FLAG)
    IF(IS_DEBUG)
        SET(WX_DEBUG_FLAG "d")
    ENDIF(IS_DEBUG)
    STRING(REGEX REPLACE "/" "\\\\" WX_SRC_WINDIR ${WX_SRC_DIR})
    STRING(REGEX REPLACE "/" "\\\\" WX_INSTALL_WINDIR ${CMAKE_INSTALL_PREFIX})
    
    CONFIGURE_FILE(${WX_PATCH_DIR}/install.bat.in
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

ELSE(WIN32)
    SET(WX_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/wxWidgets-prefix/src/wxWidgets)
    SET(WX_CONFIGURE
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
ENDIF(WIN32)

ExternalProject_Add_Step(wxWidgets CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-wxWidgets.cmake ${CMAKE_INSTALL_PREFIX}/fw-wxWidgets.cmake
    COMMENT "Install configuration file"
)
