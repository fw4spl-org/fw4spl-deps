CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(qtBuilder)

INCLUDE(ExternalProject)

SET(QT5_URL "http://download.qt-project.org/official_releases/qt/5.2/5.2.1/single/qt-everywhere-opensource-src-5.2.1.tar.gz")
GET_CACHED_URL(${QT5_URL} CACHED_URL)



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
    IF(UNIX AND NOT APPLE)
        SET(MKSPEC linux-g++)
    ELSEIF(APPLE)
        SET(MKSPEC macx-clang)
    ENDIF()
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
                     -system-libjpeg
                     -system-freetype
                     -nomake examples
                     -no-fontconfig
                     -opengl desktop
                     -prefix ${CMAKE_INSTALL_PREFIX}
                     -I ${CMAKE_INSTALL_PREFIX}/include
                     -L ${CMAKE_INSTALL_PREFIX}/lib
                     -device-option 
)


IF(APPLE)
    LIST(APPEND QT_CONFIGURE_CMD 
        -no-glib
        -no-rpath
        -separate-debug-info
        -skip webkit
        -framework
        )
    IF(${QT_BUILD_TYPE} MATCHES "release")
        LIST(APPEND QT_CONFIGURE_CMD 
            -release
            )
    ENDIF()
ELSEIF(WIN32)
    SET(EXTRA_DEPENDS icu4c)
    LIST(APPEND QT_CONFIGURE_CMD 
        -${QT_BUILD_TYPE}
        -I ${CMAKE_INSTALL_PREFIX}/include/icu
        )
ELSEIF(UNIX)
        LIST(APPEND QT_CONFIGURE_CMD 
        -${QT_BUILD_TYPE}
        -system-xcb

        )
ENDIF()

SET(QT_PATCH_CMD)

IF(WIN32)
    LIST(APPEND QT_CONFIGURE_CMD
        -arch windows
        -no-angle
        -no-vcproj
        -platform win32-msvc2010
        -l zlib
        -l jpeg
        -l png
        -l freetype
    )
    SET(QT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    SET(QT_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/qt-prefix/src/qt)
    #hack: rcc.exe need zlib in path
    SET(QT_PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different ${QT_PATCH_DIR}/configure.bat ${QT_SRC_DIR}/qtbase/configure.bat
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qtbase/bin/${ZLIB_LIB_NAME}.dll
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qttools/bin/${ZLIB_LIB_NAME}.dll)
ENDIF(WIN32)

IF(NOT WIN32)
    SET(JOBS "-j${NUMBER_OF_PARALLEL_BUILD}")
    SET(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_qt}")
ELSE(NOT WIN32)
    SET(JOBS "")
    SET(INSTALL_ROOT "")
ENDIF(NOT WIN32) 

ExternalProject_Add(
    qt
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_MD5 a78408c887c04c34ce615da690e0b4c8
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${QT_PATCH_CMD}
    DEPENDS zlib jpeg libpng tiff icu4c freetype ${EXTRA_DEPENDS} 
    CONFIGURE_COMMAND ${ENV_WRAPPER} ${QT_CONFIGURE_CMD}
    BUILD_COMMAND ${ENV_WRAPPER} ${MAKE_QT} ${JOBS} -f Makefile
    INSTALL_COMMAND ${ENV_WRAPPER} ${MAKE_QT} ${JOBS} -f Makefile ${INSTALL_ROOT} install
    STEP_TARGETS CopyConfigFileToInstall
)

IF(NOT WIN32)
    ExternalProject_Add_Step(qt COPY_FILES
            COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_qt} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
ENDIF()

ExternalProject_Add_Step(qt CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-Qt5.cmake ${CMAKE_INSTALL_PREFIX}/fw-Qt5.cmake
    COMMENT "Install configuration file"
)

