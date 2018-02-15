set(MKSPEC macx-clang)
configure_file(envwrapper/env.sh.in
    ${CMAKE_CURRENT_BINARY_DIR}/env.sh @ONLY
)
set(ENV_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/env.sh)

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
    -opengl desktop

    -nomake examples
    -nomake tests

    -no-glib
    -no-fontconfig
    -no-xcb
)

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    list(APPEND QT_CONFIGURE_CMD
        -no-framework
    )
endif()

set(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_qt}")
ExternalProject_Add(
    qt
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_HASH SHA256=${QT5_HASHSUM}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${QT_PATCH_CMD}
    DEPENDS zlib jpeg libpng tiff icu4c freetype
    CONFIGURE_COMMAND ${ENV_WRAPPER} ${QT_CONFIGURE_CMD}
    BUILD_COMMAND ${ENV_WRAPPER} ${MAKE} -j${NUMBER_OF_PARALLEL_BUILD} -f Makefile
    INSTALL_COMMAND ${ENV_WRAPPER} ${MAKE} -j${NUMBER_OF_PARALLEL_BUILD} -f Makefile ${INSTALL_ROOT} install
)

ExternalProject_Add_Step(qt COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_qt} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)
