if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(MKSPEC linux-clang)
else()
    set(MKSPEC linux-g++)
endif()

configure_file(envwrapper/env.sh.in
    ${CMAKE_CURRENT_BINARY_DIR}/env.sh @ONLY
)
set(ENV_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/env.sh)

# qt's configure is not an autotool configure
set(QT_CONFIGURE_CMD ./configure
    -prefix ${CMAKE_INSTALL_PREFIX}
    -I ${CMAKE_INSTALL_PREFIX}/include
    -L ${CMAKE_INSTALL_PREFIX}/lib
    -${QT_BUILD_TYPE}
    ${QT_SKIP_MODULES_LIST}
    
    -shared
    -opensource
    -confirm-license    
    -system-zlib
    -system-libpng
    -system-libjpeg
    -system-freetype
    
    -nomake examples
    -nomake tests
    
    -no-fontconfig
    -no-dbus
    
    -opengl desktop
    -qt-xcb
    -c++11
    #We now build qt with gstreamer 1.0 (be sure you have installed libgstreamer-1.0-dev and libgstreamer-plugins-base1.0-dev)
    -gstreamer 1.0
)

set(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_qt}")

set(QT_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${QT_PATCH_DIR}/MouseEvents.diff -d <SOURCE_DIR>)

ExternalProject_Add(
    qt
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_HASH MD5=${QT5_HASHSUM}
    PATCH_COMMAND ${QT_PATCH_CMD}
    BUILD_IN_SOURCE 1
    DEPENDS zlib jpeg libpng tiff icu4c freetype
    CONFIGURE_COMMAND ${ENV_WRAPPER} ${QT_CONFIGURE_CMD}
    BUILD_COMMAND ${ENV_WRAPPER} ${MAKE}
    INSTALL_COMMAND ${ENV_WRAPPER} ${MAKE} -f Makefile ${INSTALL_ROOT} install
)

ExternalProject_Add_Step(qt COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_qt} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
    DEPENDEES install
)
