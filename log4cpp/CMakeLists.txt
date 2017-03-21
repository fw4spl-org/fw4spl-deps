cmake_minimum_required(VERSION 3.0)

project(log4cpp)

include(ExternalProject)
set(CACHED_URL "https://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.1.tar.gz/download") 
set(LOG4CPP_LIBRARY_NAME Log4Cpp)

set(LOG4CPP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DBUILD_STATIC_LIBS:BOOL=OFF
                    -DLIBRARY_INSTALL_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib
                    -DLIBRARY_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                    -DLIBRARY_DESTINATION:PATH=${CMAKE_INSTALL_PREFIX}
)

if(WIN32)
	ExternalProject_Add(
        log4cpp
        URL ${CACHED_URL}
        URL_HASH SHA256=35abf332630a6809c969276b1d60b90c81a95daf24c86cfd7866ffef72f9bed0
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DOWNLOAD_NAME log4cpp-1.1.1.zip
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${COMMON_CMAKE_ARGS}
    )
else()
    ExternalProject_Add(
        log4cpp
        URL ${CACHED_URL}
        URL_HASH SHA256=35abf332630a6809c969276b1d60b90c81a95daf24c86cfd7866ffef72f9bed0
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DOWNLOAD_NAME log4cpp-1.1.1.zip
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${SET_COMPILER_ENV} ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ./configure
                        --enable-shared
                        --disable-static
                        --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ${MAKE}
        INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ${MAKE} DESTDIR=${INSTALL_PREFIX_LOG4CPP} install
    )
endif()


ExternalProject_Add_Step(log4cpp CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindLog4Cpp.cmake ${CMAKE_INSTALL_PREFIX}/FindLog4Cpp.cmake 
    COMMENT "Install CMake find package"
    DEPENDEES install
)
