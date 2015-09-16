cmake_minimum_required(VERSION 2.8)

project(qtBuilder)

include(ExternalProject)

set(QT5_URL "http://download.qt.io/official_releases/qt/5.5/5.5.0/single/qt-everywhere-opensource-src-5.5.0.tar.gz")
set(QT5_HASHSUM 828594c91ba736ce2cd3e1e8a6146452)

getCachedUrl(${QT5_URL} CACHED_URL)

string(TOLOWER "${CMAKE_BUILD_TYPE}" QT_BUILD_TYPE)

set(QT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(QT_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/qt-prefix/src/qt)

if(WIN32)
    include(qt_windows.cmake)
elseif(APPLE)
    include(qt_apple.cmake)
elseif(UNIX)
    include(qt_linux.cmake)
else()
    message(SEND_ERROR "Unknown plateform.")
endif()

if(APPLE)
    ExternalProject_Add_Step(qt FRAMEWORK_FIXUP
        COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/../CMake/OSXTools/osx_qt_symbolic_link.py
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
        DEPENDEES COPY_FILES
     )
endif()

ExternalProject_Add_Step(qt CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-Qt5.cmake ${CMAKE_INSTALL_PREFIX}/fw-Qt5.cmake
    COMMENT "Install configuration file"
)
