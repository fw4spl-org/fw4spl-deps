cmake_minimum_required(VERSION 3.0)

project(orbslam2Builder)

include(ExternalProject)
set(CACHED_URL https://github.com/fw4spl-org/ORB_SLAM2/archive/v0.5.1.tar.gz)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(ORBSLAM2_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
    -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
    -DBoost_COMPILER:STRING=${Boost_COMPILER}
    -DBOOST_ROOT:PATH=${CMAKE_INSTALL_PREFIX}
    -DBoost_USE_DEBUG_PYTHON:BOOL=ON
    -DBoost_USE_MULTITHREADED:BOOL=ON
    -DBoost_USE_STATIC_LIBS:BOOL=OFF
    -DBUILD_UTILITY:BOOL=ON
)

ExternalProject_Add(
    orbslam2
    URL ${CACHED_URL}
    URL_HASH SHA256=13ba469c1bdf89f77bafd50ca477ea1fbda10c0b5424ce7a65fdbcd2a22252e7 
    DOWNLOAD_NAME orbslam2-0.5.1.tar.gz
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS boost opencv eigen
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ORBSLAM2_CMAKE_ARGS}
)

ExternalProject_Add_Step(orbslam2 CopyFindFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindORB_SLAM2.cmake
                                     ${CMAKE_INSTALL_PREFIX}/FindORB_SLAM2.cmake
    COMMENT "Install FindORB_SLAM2.cmake file"
    DEPENDEES install
)

# Convert txt vocabulary format to binary
if(NOT "${CUDA_TOOLKIT_ROOT_DIR}" STREQUAL "")
    if(WIN32)
        set(ORBSLAM2_GENERATEVOCABULARY_CMD COMMAND set "PATH=${CUDA_TOOLKIT_ROOT_DIR}/bin;%PATH%")
    else()
        set(ORBSLAM2_GENERATEVOCABULARY_CMD COMMAND export "LD_LIBRARY_PATH=${CUDA_TOOLKIT_ROOT_DIR}/lib:\${LD_LIBRARY_PATH}")
    endif()
endif()

set(ORBSLAM2_GENERATEVOCABULARY_CMD
    ${ORBSLAM2_GENERATEVOCABULARY_CMD}
    COMMAND ${CMAKE_INSTALL_PREFIX}/bin/bin_vocabulary
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/ORBvoc.bin ${CMAKE_INSTALL_PREFIX}/share/ORB_SLAM2/ORBvoc.bin
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_INSTALL_PREFIX}/bin/ORBvoc.txt ${CMAKE_INSTALL_PREFIX}/bin/ORBvoc.bin
    )

ExternalProject_Add_Step(orbslam2 generateVocabulary
    ${ORBSLAM2_GENERATEVOCABULARY_CMD}
    WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/bin
    COMMENT "Generate Vocabulary"
    DEPENDEES install
)
