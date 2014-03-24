CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(qtBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://download.qt-project.org/official_releases/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz CACHED_URL)

FIND_PROGRAM(MAKE_QT jom)
IF(NOT MAKE_QT)
    SET(MAKE_QT ${MAKE})
ENDIF()

STRING(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
SET(QT_BUILD_TYPE debug)
IF("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    SET(QT_BUILD_TYPE release)
ENDIF()

SET(ENV_WRAPPER)
IF(NOT WIN32)
    CONFIGURE_FILE(envwrapper/env.sh.in 
        ${CMAKE_CURRENT_BINARY_DIR}/env.sh @ONLY
        )
    SET(ENV_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/env.sh)
ENDIF()

# qt's configure is not an autotool configure
SET(QT_CONFIGURE_CMD ./configure
    -shared
    -opensource
    -confirm-license
    -system-zlib
    -system-libpng
    -qt-libmng
    -system-libtiff
    -system-libjpeg
    -nomake examples
    -nomake demos
    -nomake docs
    #-no-fontconfig
    -webkit
    -prefix ${CMAKE_INSTALL_PREFIX}
    -I ${CMAKE_INSTALL_PREFIX}/include
    -L ${CMAKE_INSTALL_PREFIX}/lib
    )


IF(APPLE)
    LIST(APPEND QT_CONFIGURE_CMD 
        -no-glib
        -no-rpath
        -separate-debug-info
        -framework
        -no-webkit
        )
    IF(${QT_BUILD_TYPE} MATCHES "Release")
        LIST(APPEND QT_CONFIGURE_CMD 
            -release
            )
    ENDIF()
ELSE()
    SET(EXTRA_DEPENDS icu4c)
    LIST(APPEND QT_CONFIGURE_CMD 
        -${QT_BUILD_TYPE}
        -I ${CMAKE_INSTALL_PREFIX}/include/icu
        )
ENDIF()

SET(QT_PATCH_CMD)
IF(WIN32)
    LIST(APPEND QT_CONFIGURE_CMD
        -arch windows
        -no-vcproj
        -platform win32-msvc2010
        )
    SET(QT_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/qt-prefix/src/qt)
    #hack: rcc.exe need zlib in path
    SET(QT_PATCH_CMD ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/bin/${ZLIB_LIB_NAME}.dll)
ELSEIF(APPLE)
    SET(QT_PATCH_CMD patch -t -N -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/patch/osx10.9-qcorewlanengine.patch )
ENDIF()

ExternalProject_Add(
    qt
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_MD5 1864987bdbb2f58f8ae8b350dfdbe133
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${QT_PATCH_CMD}
    DEPENDS zlib jpeg libpng tiff ${EXTRA_DEPENDS}
    CONFIGURE_COMMAND ${ENV_WRAPPER} ${QT_CONFIGURE_CMD}
    BUILD_COMMAND ${ENV_WRAPPER} ${MAKE_QT} -f Makefile
    INSTALL_COMMAND ${ENV_WRAPPER} ${MAKE_QT} -j1 -f Makefile install
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    )
