find_program(MAKE_QT jom CMAKE_FIND_ROOT_PATH_BOTH)

if(NOT MAKE_QT)
    set(MAKE_QT ${MAKE})
endif()

if(MSVC14)
    set(PLATFORM "win32-msvc2015")
elseif(MSVC12)
    set(PLATFORM "win32-msvc2013")
elseif(MSVC10)
    set(PLATFORM "win32-msvc2010")
else()
    message(SEND_ERROR "Compiler version not supported")
endif()

# qt's configure is not an autotool configure
set(QT_CONFIGURE_CMD ./configure.bat
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
    ${QT_SKIP_MODULES_LIST}
    -prefix ${INSTALL_PREFIX_qt}
    -I ${CMAKE_INSTALL_PREFIX}/include
    -L ${CMAKE_INSTALL_PREFIX}/lib
    -${QT_BUILD_TYPE}
    -I ${CMAKE_INSTALL_PREFIX}/include/icu
    -plugindir ${INSTALL_PREFIX_qt}/bin/qt5/plugins
    -no-angle
    -platform ${PLATFORM}
    -mediaplayer-backend wmf
    -mp
    -silent
)

#hack: rcc.exe need zlib in path
set(QT_PATCH_CMD ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qtbase/bin/${ZLIB_LIB_NAME}.dll
         COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qttools/bin/${ZLIB_LIB_NAME}.dll)

ExternalProject_Add(
    qt
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_HASH SHA256=${QT5_HASHSUM}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${QT_PATCH_CMD}
    DEPENDS zlib jpeg libpng tiff icu4c freetype
    CONFIGURE_COMMAND ${QT_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE_QT} -f Makefile
    INSTALL_COMMAND ${MAKE_QT} -f Makefile install
)

ExternalProject_Add_Step(qt COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_qt} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)
