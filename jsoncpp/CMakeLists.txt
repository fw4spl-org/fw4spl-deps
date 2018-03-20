cmake_minimum_required(VERSION 3.0)

PROJECT(jsonCppBuilder)

INCLUDE(ExternalProject)

set(CACHED_URL https://github.com/open-source-parsers/jsoncpp/archive/1.7.1.zip)

set(JSONCPP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DBUILD_STATIC_LIBS:BOOL=OFF
                    -DLIBRARY_INSTALL_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib
)

ExternalProject_Add(
    jsoncpp
    URL ${CACHED_URL}
    URL_HASH SHA256=22eea1786492a9d14efb1738ea74a1b1a5164dbf9a5e40ef777106c907250ac1
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME jsoncpp-1.7.1.zip
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${JSONCPP_CMAKE_ARGS}
)

#seems needed to compile ODIL
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fPIC")
endif()

fwInstallFile(
    BINPKG jsoncpp
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindJSONCPP.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindJSONCPP.cmake
)
