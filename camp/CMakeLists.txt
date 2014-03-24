CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(campBuilder)

INCLUDE(ExternalProject)

SET(CAMP_CMAKE_ARGS 
    -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DBUILD_DOXYGEN:BOOL=OFF
)

GET_CACHED_URL(https://github.com/greenjava/camp/archive/0.7.1.1.tar.gz CACHED_URL)

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
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/FindCAMP.cmake ${CMAKE_INSTALL_PREFIX}/FindCAMP.cmake
    COMMENT "Install configuration file"
)


