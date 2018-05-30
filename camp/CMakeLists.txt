cmake_minimum_required(VERSION 3.0)

project(campBuilder)

include(ExternalProject)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )
set(CAMP_CMAKE_ARGS ${COMMON_CMAKE_ARGS})

if(ANDROID)
    if( ${ANDROID_STL} MATCHES "gnustl_shared" )
        set(CAMP_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")
        list(APPEND CAMP_CMAKE_ARGS
            -DCMAKE_CXX_FLAGS=${CAMP_CMAKE_CXX_FLAGS} )
    endif()
endif()

set(CAMP_VERSION 0.8.2)
set(CACHED_URL https://github.com/fw4spl-org/camp/archive/${CAMP_VERSION}.zip)

ExternalProject_Add(
    camp
    URL ${CACHED_URL}
    URL_HASH SHA256=fef09c13fab437024aa82609c1caab6cc1ad84c788fa31c8d3c9dd7acfebb50b
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME camp-${CAMP_VERSION}.zip
    DEPENDS boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CAMP_CMAKE_ARGS}
)

fwInstallFile(
    BINPKG camp
    SRC ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindCAMP.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindCAMP.cmake
)
