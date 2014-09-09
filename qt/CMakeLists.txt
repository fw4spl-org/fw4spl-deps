cmake_minimum_required(VERSION 2.8)

project(qtBuilder)

include(ExternalProject)

set(QT5_URL "http://download.qt-project.org/official_releases/qt/5.2/5.2.1/single/qt-everywhere-opensource-src-5.2.1.tar.gz")
getCachedUrl(${QT5_URL} CACHED_URL)



find_program(MAKE_QT jom)
if(NOT MAKE_QT)
    set(MAKE_QT ${MAKE})
endif()

string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
set(QT_BUILD_TYPE debug)
if("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    set(QT_BUILD_TYPE release)
endif()

set(ENV_WRAPPER)
if(NOT WIN32)
    if(UNIX AND NOT APPLE)
        set(MKSPEC linux-g++)
    elseif(APPLE)
        set(MKSPEC macx-clang)
    endif()
    configure_file(envwrapper/env.sh.in 
        ${CMAKE_CURRENT_BINARY_DIR}/env.sh @ONLY
        )
    set(ENV_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/env.sh)
endif()

# qt's configure is not an autotool configure
set(QT_CONFIGURE_CMD ./configure
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


if(APPLE)
    list(APPEND QT_CONFIGURE_CMD 
        -no-glib
        -no-rpath
        -separate-debug-info
        -skip webkit
        -framework
        )
    if(${QT_BUILD_TYPE} MATCHES "release")
        list(APPEND QT_CONFIGURE_CMD 
            -release
            )
    endif()
elseif(WIN32)
    set(EXTRA_DEPENDS icu4c)
    list(APPEND QT_CONFIGURE_CMD 
        -${QT_BUILD_TYPE}
        -I ${CMAKE_INSTALL_PREFIX}/include/icu
        )
elseif(UNIX)
        list(APPEND QT_CONFIGURE_CMD 
        -${QT_BUILD_TYPE}
        -system-xcb

        )
endif()

set(QT_PATCH_CMD)

if(WIN32)
    list(APPEND QT_CONFIGURE_CMD
        -arch windows
        -no-angle
        -no-vcproj
        -platform win32-msvc2010
        -l zlib
        -l jpeg
        -l png
        -l freetype
    )
    set(QT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    set(QT_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/qt-prefix/src/qt)
    #hack: rcc.exe need zlib in path
    set(QT_PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different ${QT_PATCH_DIR}/configure.bat ${QT_SRC_DIR}/qtbase/configure.bat
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qtbase/bin/${ZLIB_LIB_NAME}.dll
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qttools/bin/${ZLIB_LIB_NAME}.dll)
endif(WIN32)

if(NOT WIN32)
    set(JOBS "-j${NUMBER_OF_PARALLEL_BUILD}")
    set(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_qt}")
else(NOT WIN32)
    set(JOBS "")
    set(INSTALL_ROOT "")
endif(NOT WIN32) 

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

if(NOT WIN32)
    ExternalProject_Add_Step(qt COPY_FILES
            COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_qt} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
endif()

ExternalProject_Add_Step(qt CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-Qt5.cmake ${CMAKE_INSTALL_PREFIX}/fw-Qt5.cmake
    COMMENT "Install configuration file"
)

