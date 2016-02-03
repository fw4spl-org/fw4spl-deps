cmake_minimum_required(VERSION 3.0)

project(campBuilder)

include(ExternalProject)

if(NOT WIN32)
    set(CAMP_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")
    if(APPLE)
       set(CAMP_CMAKE_CXX_FLAGS "${CAMP_CMAKE_CXX_FLAGS} --stdlib=libc++")
    endif(APPLE)
else()
    set(CAMP_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endif()

set(CAMP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_DOXYGEN:BOOL=OFF
                    -DBOOST_INCLUDEDIR:PATH=${CMAKE_INSTALL_PREFIX}/include/boost-1_57
                    -DCMAKE_CXX_FLAGS=${CAMP_CMAKE_CXX_FLAGS}
)

set(CACHED_URL https://github.com/fw4spl-org/camp/archive/0.7.1.3.zip)

ExternalProject_Add(
    camp
    URL ${CACHED_URL}
    URL_HASH SHA256=871ee4879a131ade7ecb397e62d59ec78c8602abdad6de5349c215e929c02f8d
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME camp_0.7.1.3.zip
    DEPENDS boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CAMP_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(camp CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindCAMP.cmake ${CMAKE_INSTALL_PREFIX}/FindCAMP.cmake
    COMMENT "Install configuration file"
)
