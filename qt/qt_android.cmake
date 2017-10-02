if(CMAKE_HOST_WIN32)

    set(QT_SDK_PATH CACHE PATH "Qt SDK for Android (C:/Qt/Qt5.6.1/5.6/android_armv7)")
    if(NOT QT_SDK_PATH)
        message(FATAL_ERROR  "Qt SDK path not defined.")
    elseif(NOT EXISTS "${QT_SDK_PATH}/bin/moc.exe")
        message(FATAL_ERROR  "Qt SDK path '${QT_SDK_PATH}' is not valid.")
    endif()

    ExternalProject_Add(
        qt
        SOURCE_DIR ${QT_SDK_PATH}
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND COMMAND ${CMAKE_COMMAND} -E copy_directory ${QT_SDK_PATH} ${CMAKE_INSTALL_PREFIX}
    )

else()

    set(QT5_URL "http://download.qt.io/official_releases/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.gz")
    set(QT5_HASHSUM 59f0216819152b77536cf660b015d784)
    set(ANDROID_SDK_ROOT $ENV{ANDROID_SDK})
    set(ANDROID_API_VERSION "android-${ANDROID_NATIVE_API_LEVEL}")

    #ANDROID_NDK_HOST_SYSTEM_NAME is defined by the android.toolchain.cmake
    if("${ANDROID_NDK_HOST_SYSTEM_NAME}" STREQUAL "")
        message( FATAL_ERROR  "Your system cannot be identified, maybe you forget to use android toolchain ?")
    else()
        set(SYSTEM ${ANDROID_NDK_HOST_SYSTEM_NAME})
    endif()

    set(QT_CONFIGURE_CMD ./configure
        -prefix ${CMAKE_INSTALL_PREFIX}
        -I ${CMAKE_INSTALL_PREFIX}/include
        -L ${CMAKE_INSTALL_PREFIX}/lib
        -plugindir ${CMAKE_INSTALL_PREFIX}/lib/qt5/plugins
        -${QT_BUILD_TYPE}
        -xplatform android-g++
        -opensource
        -confirm-license
        -nomake tests
        -nomake examples
        -android-ndk $ENV{ANDROID_NDK}
        -android-sdk ${ANDROID_SDK_ROOT}
        -android-toolchain-version ${ANDROID_COMPILER_VERSION}
        -no-warnings-are-errors
        -system-zlib
        -system-freetype

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
        -skip qt3d
        -skip qtdeclarative
        -skip qtquick1
        -skip qtquickcontrols
        -skip qtcanvas3d
        -skip qtgraphicaleffects
        -skip qtscript
        -skip qtwayland
        -skip qtserialport
        -skip qtdoc
        -skip macextras
        -skip qtwinextras
        -skip x11extras
        -skip qttools

    )

    set(QT_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${QT_PATCH_DIR}/android/qlogging.diff -d <SOURCE_DIR>)

    if(CMAKE_HOST_APPLE)
        list(APPEND QT_PATCH_CMD COMMAND ${PATCH_EXECUTABLE} -p1 -i ${QT_PATCH_DIR}/xcode8.diff -d <SOURCE_DIR>)
    endif()

    list(APPEND QT_CONFIGURE_CMD
        -android-ndk-host ${SYSTEM}
        )

    set(INSTALL_ROOT "INSTALL_ROOT=${INSTALL_PREFIX_qt}")

    ExternalProject_Add(
        qt
        URL ${QT5_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        URL_HASH MD5=${QT5_HASHSUM}
        BUILD_IN_SOURCE 1
        PATCH_COMMAND ${QT_PATCH_CMD}
        DEPENDS zlib jpeg libpng freetype
        CONFIGURE_COMMAND ${QT_CONFIGURE_CMD}
        BUILD_COMMAND ${ENV_WRAPPER} ${MAKE} -j${NUMBER_OF_PARALLEL_BUILD} -f Makefile
        INSTALL_COMMAND ${MAKE} -j${NUMBER_OF_PARALLEL_BUILD} -f Makefile ${INSTALL_ROOT} install
    )

    ExternalProject_Add_Step(qt COPY_FILES
            COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_qt} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )
endif()
