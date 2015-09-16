find_program(MAKE_QT jom CMAKE_FIND_ROOT_PATH_BOTH)

if(NOT MAKE_QT)
    set(MAKE_QT ${MAKE})
endif()

if(MSVC12)
    set(PLATFORM "win32-msvc2013")
elseif(MSVC10)
    set(PLATFORM "win32-msvc2010")
else()
    message(SEND_ERROR "Compiler version not supported")
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
    
    -skip qtactiveqt
    -skip qtconnectivity
    -skip qtenginio
    -skip qtsensors
    -skip qttranslations
    -skip qtwayland
    -skip qtwebengine
    -skip qtwebchannel
    -skip qtwebkit 
    -skip qtwebkit-examples
    -skip qtwebsockets 
    
    -prefix ${CMAKE_INSTALL_PREFIX}
    -I ${CMAKE_INSTALL_PREFIX}/include
    -L ${CMAKE_INSTALL_PREFIX}/lib
    -${QT_BUILD_TYPE}
    -I ${CMAKE_INSTALL_PREFIX}/include/icu
    -arch windows
    -no-angle
    -c++11
    -platform ${PLATFORM}
    -l zlib
    -l jpeg
    -l png
    -l freetype
)

#hack: rcc.exe need zlib in path
set(QT_PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different ${QT_PATCH_DIR}/configure.bat ${QT_SRC_DIR}/qtbase/configure.bat
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qtbase/bin/${ZLIB_LIB_NAME}.dll
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll ${QT_SRC_DIR}/qttools/bin/${ZLIB_LIB_NAME}.dll)

ExternalProject_Add(
    qt
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    URL_HASH MD5=${QT5_HASHSUM}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${QT_PATCH_CMD}
    DEPENDS zlib jpeg libpng tiff icu4c freetype
    CONFIGURE_COMMAND ${QT_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE_QT} -f Makefile
    INSTALL_COMMAND ${MAKE_QT} -f Makefile install
    STEP_TARGETS CopyConfigFileToInstall
)
