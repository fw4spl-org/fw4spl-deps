cmake_minimum_required(VERSION 3.0)

project(log4cpp)

include(ExternalProject)
set(CACHED_URL "https://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.1.tar.gz/download")

set(LOG4CPP_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(LOG4CPP_CMAKE_ARGS ${COMMON_CMAKE_ARGS} -DBUILD_SHARED_LIBS:BOOL=ON)

set(LOG4CPP_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${LOG4CPP_PATCH_DIR}/log4cpp.diff -d <SOURCE_DIR>)

if(UNIX)
    # We need to run ./configure in order to generate log4cpp/config.h file on Unixes
    # This is not really ideal since we will use CMake at the end to build but that's the only way I found to create this file
    # But this way we can use CMake on all platforms and that's better especially because the _uninstall target works better in this case
    set(LOG4CPP_CONFIGURE_COMMAND ${SET_COMPILER_ENV} ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ./configure
                                --enable-shared
                                --disable-static
                                --prefix=${CMAKE_INSTALL_PREFIX}
                                COMMAND
                                ${CMAKE_COMMAND} -E chdir <BINARY_DIR> ${CMAKE_COMMAND} <SOURCE_DIR> -G "Unix Makefiles" ${LOG4CPP_CMAKE_ARGS})
endif()

ExternalProject_Add(
    log4cpp
    URL ${CACHED_URL}
    URL_HASH SHA256=35abf332630a6809c969276b1d60b90c81a95daf24c86cfd7866ffef72f9bed0
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME log4cpp-1.1.1.zip
    PATCH_COMMAND ${LOG4CPP_PATCH_CMD}
    CONFIGURE_COMMAND ${LOG4CPP_CONFIGURE_COMMAND}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${LOG4CPP_CMAKE_ARGS}
)

fwInstallFile(
    BINPKG log4cpp
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindLog4Cpp.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindLog4Cpp.cmake
)
