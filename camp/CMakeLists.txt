cmake_minimum_required(VERSION 2.8)

project(campBuilder)

include(ExternalProject)

set(CAMP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_DOXYGEN:BOOL=OFF
                    -DBOOST_INCLUDEDIR:PATH=${CMAKE_INSTALL_PREFIX}/include/boost-1_57
)

getCachedUrl(https://github.com/greenjava/camp/archive/0.7.1.1.tar.gz CACHED_URL)

ExternalProject_Add(
    camp
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CAMP_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(camp CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindCAMP.cmake ${CMAKE_INSTALL_PREFIX}/FindCAMP.cmake
    COMMENT "Install configuration file"
)


