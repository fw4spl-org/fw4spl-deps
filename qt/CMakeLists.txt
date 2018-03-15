cmake_minimum_required(VERSION 3.0)

project(qtBuilder)

include(ExternalProject)

set(QT5_URL "http://download.qt.io/official_releases/qt/5.9/5.9.4/single/qt-everywhere-opensource-src-5.9.4.tar.xz")
set(QT5_HASHSUM e3acd9cbeafba3aed9f14592f4d70bf0b255e0203943e8d2b4235002268274d5)

set(CACHED_URL ${QT5_URL})

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    set(QT_BUILD_TYPE debug)
elseif(${CMAKE_BUILD_TYPE} STREQUAL "RelWithDebInfo")
    set(QT_BUILD_TYPE release -force-debug-info)
else()
    set(QT_BUILD_TYPE release)
endif()

set(QT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(QT_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/qt-prefix/src/qt)

set(QT_SKIP_MODULES_LIST
    -skip qtactiveqt
    -skip qtconnectivity
    -skip qtsensors
    -skip qttranslations
    -skip qtwayland
    -skip qtwebengine
    -skip qtwebchannel
    -skip qtwebsockets
    -skip qtdeclarative
    -skip qtquickcontrols
    -skip qtcanvas3d
    -skip qtgraphicaleffects
    -skip qtscript
    -skip qtserialport
    -skip qtdoc
    -skip qtlocation)

if(WIN32)
    include(qt_windows.cmake)
elseif(APPLE)
    include(qt_apple.cmake)
elseif(ANDROID)
    include(qt_android.cmake)
elseif(UNIX)
    include(qt_linux.cmake)
else()
    message(SEND_ERROR "Unknown plateform.")
endif()

if(APPLE)
    ExternalProject_Add_Step(qt FRAMEWORK_FIXUP
        COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/OSXTools/osx_qt_symbolic_link.py
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
        DEPENDEES COPY_FILES
     )
endif()

ExternalProject_Add_Step(qt CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-Qt5.cmake ${CMAKE_INSTALL_PREFIX}/fw-Qt5.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
add_custom_target(qt_cmake_uninstall
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_INSTALL_PREFIX}/fw-Qt5.cmake
    COMMENT "Uninstall Qt configuration file"
)
add_dependencies(qt_uninstall qt_cmake_uninstall)

ExternalProject_Add_Step(qt CopyFonts
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/fonts ${CMAKE_INSTALL_PREFIX}/lib/fonts
    COMMENT "Install fonts"
    DEPENDEES install
)
add_custom_target(qt_fonts_uninstall
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_INSTALL_PREFIX}/lib/fonts
    COMMENT "Uninstall Qt fonts"
)
add_dependencies(qt_uninstall qt_fonts_uninstall)
