cmake_minimum_required(VERSION 3.0)

project(campBuilder)

include(ExternalProject)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )
set(CAMP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_DOXYGEN:BOOL=OFF
)

if(ANDROID)
    if( ${ANDROID_STL} MATCHES "gnustl_shared" )
        set(CAMP_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")
        list(APPEND CAMP_CMAKE_ARGS
            -DCMAKE_CXX_FLAGS=${CAMP_CMAKE_CXX_FLAGS} )
    endif()
endif()

set(CACHED_URL https://github.com/fw4spl-org/camp/archive/0.7.1.4.zip)

ExternalProject_Add(
    camp
    URL ${CACHED_URL}
    URL_HASH SHA256=be2e24e6adff4c3bd62746c013943166028f7af75708f77f171c1b936ed02fca
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME camp_0.7.1.4.zip
    DEPENDS boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CAMP_CMAKE_ARGS}
)

ExternalProject_Add_Step(camp CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindCAMP.cmake ${CMAKE_INSTALL_PREFIX}/FindCAMP.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
