if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(PLATFORM linux-clang)
else()
    set(PLATFORM linux-g++)
endif()

# qt's configure is not an autotool configure
set(QT_CONFIGURE_CMD ./configure
    -prefix ${CMAKE_INSTALL_PREFIX}
    -I ${CMAKE_INSTALL_PREFIX}/include
    -L ${CMAKE_INSTALL_PREFIX}/lib
    -plugindir ${CMAKE_INSTALL_PREFIX}/lib/qt5/plugins
    -${QT_BUILD_TYPE}
    ${QT_SKIP_MODULES_LIST}

    -shared
    -opensource
    -confirm-license
    -system-zlib
    -system-libpng
    -system-libjpeg
    -system-freetype
    -platform ${PLATFORM}

    -nomake examples
    -nomake tests

    -no-dbus
    -no-fontconfig

    -opengl desktop
    -qt-xcb
    -c++std c++11
    # We now build qt with gstreamer 1.0 (be sure you have installed libgstreamer-1.0-dev and libgstreamer-plugins-base1.0-dev)
    -gstreamer 1.0
)

set(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_qt}")

ExternalProject_Add(
    qt
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_HASH SHA256=${QT5_HASHSUM}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${QT_PATCH_CMD}
    CONFIGURE_COMMAND ${QT_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} -f Makefile ${INSTALL_ROOT} install
)

ExternalProject_Add_Step(qt COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_qt} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)
