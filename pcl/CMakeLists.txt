cmake_minimum_required(VERSION 3.0)

project(pclBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/PointCloudLibrary/pcl/archive/pcl-1.8.1.tar.gz)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

if(WIN32)
    set(OPENNI2_LIBRARY "OpenNI2.lib")
elseif(APPLE)
    set(OPENNI2_LIBRARY "libOpenNI2.dylib")
else()
    set(OPENNI2_LIBRARY "libOpenNI2.so")
endif()

set(PCL_CMAKE_ARGS      ${COMMON_CMAKE_ARGS}
                        -DBUILD_apps:BOOL=OFF
                        -DBUILD_examples:BOOL=OFF
                        -DBUILD_common:BOOL=ON
                        -DBUILD_2d:BOOL=ON
                        -DBUILD_features:BOOL=ON
                        -DBUILD_filters:BOOL=ON
                        -DBUILD_geometry:BOOL=ON
                        -DBUILD_io:BOOL=ON
                        -DBUILD_kdtree:BOOL=ON
                        -DBUILD_octree:BOOL=ON
                        -DBUILD_sample_consensus:BOOL=ON
                        -DBUILD_search:BOOL=ON
                        -DBUILD_tools:BOOL=OFF
                        -DCMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
                        -DCMAKE_CXX_COMPILER:PATH=${CMAKE_CXX_COMPILER}
                        -DBoost_COMPILER:STRING=${Boost_COMPILER}
                        -DBOOST_ROOT:PATH=${CMAKE_INSTALL_PREFIX}
                        -DBoost_USE_DEBUG_PYTHON:BOOL=ON
                        -DBoost_USE_MULTITHREADED:BOOL=ON
                        -DBoost_USE_STATIC_LIBS:BOOL=OFF
                        -DPCL_BUILD_WITH_BOOST_DYNAMIC_LINKING_WIN32:BOOL=ON
                        -DFLANN_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include/flann
                        -DVTK_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/
                        -DPCL_SHARED_LIBS:BOOL=ON
                        -DZLIB_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DWITH_PCAP:BOOL=OFF
                        -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
                        -DWITH_DAVIDSDK:BOOL=OFF
                        -DWITH_ENSENSO:BOOL=OFF
                        -DWITH_OPENNI:BOOL=OFF
                        -DWITH_RSSDK:BOOL=OFF
                        -DPCL_ENABLE_SSE:BOOL=${ENABLE_SSE_SUPPORT}
)

set(PCL_DEPENDS eigen boost flann)
if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    list(APPEND PCL_DEPENDS zlib)
endif()

if(NOT ANDROID)
    list(APPEND PCL_DEPENDS
        qt
        vtk
        openni
    )

    list(APPEND PCL_CMAKE_ARGS
        -DBUILD_TESTS:BOOL=OFF
        -DOPENNI2_INCLUDE_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/include/openni2
        -DQT_QMAKE_EXECUTABLE:PATH=${CMAKE_INSTALL_PREFIX}/bin/qmake
        -DBUILD_ml:BOOL=ON
        -DBUILD_simulation:BOOL=ON
        -DBUILD_segmentation:BOOL=ON
        -DBUILD_registration:BOOL=ON
    )
else()
    list(APPEND PCL_CMAKE_ARGS
        -DBUILD_visualization:BOOL=OFF
        -DBUILD_global_tests:BOOL=OFF
        -DBUILD_people:BOOL=OFF
        -DWITH_OPENGL:BOOL=OFF
        -DHAVE_POSIX_MEMALIGN_EXITCODE:BOOL=OFF
    )
endif()

#CUDA
if(ENABLE_PCL_CUDA)
    if(MSVC AND (NOT (MSVC_VERSION LESS 1900)))
        # Microsoft Visual Studio 2015 is supported in CUDA version > 8.0
        if(CUDA_VERSION_MAJOR LESS 8)
            message(FATAL_ERROR "MSVC 2015 is only supported with CUDA 8.0 or greater, please upgrade your CUDA installation.")
        endif()
    endif()
    #Enable GPU options
    list(APPEND PCL_CMAKE_ARGS -DBUILD_CUDA:BOOL=ON
                               -DBUILD_GPU:BOOL=ON
                               -DBUILD_gpu_kinfu:BOOL=ON
                               -DBUILD_gpu_kinfu_large_scale:BOOL=ON
                               -DBUILD_visualization:BOOL=ON
                               -DBUILD_surface:BOOL=ON
                               -DCUDA_ARCH_BIN:STRING=${BINPKGS_CUDA_ARCHS}
    )
    if (APPLE)
        list(APPEND PCL_CMAKE_ARGS -DBUILD_gpu_features:BOOL=OFF)
    endif()
    # Workaround error C1041
    if(WIN32)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /FS")
        list(APPEND PCL_CMAKE_ARGS -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
                                   -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=ON)
    else()
        # Clang >= 3.8 is not supported by CUDA 7.5
        if(UNIX AND ${CMAKE_C_COMPILER_ID} STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.7)
            list(APPEND PCL_CMAKE_ARGS -DCUDA_HOST_COMPILER:PATH=/usr/bin/gcc
                                       -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF
            )
        endif()
    endif()
endif()

set(PCL_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(PCL_PATCH_CMD   "${PATCH_EXECUTABLE}" -p1 -i "${PCL_PATCH_DIR}/kinfu.diff" -d "<SOURCE_DIR>"
            COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${PCL_PATCH_DIR}/pcl_gpu_error.diff -d <SOURCE_DIR>
            COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${PCL_PATCH_DIR}/clang_macos.diff -d <SOURCE_DIR>)

if(ANDROID)
    list (APPEND PCL_PATCH_CMD && "${PATCH_EXECUTABLE}" -p1 -i ${PCL_PATCH_DIR}/pcl_targets.diff -d <SOURCE_DIR>)
endif()
if(WIN32)
    # Fix compilation on Windows for Ensenso grabber
    list (APPEND PCL_PATCH_CMD && "${PATCH_EXECUTABLE}" -p1 -i ${PCL_PATCH_DIR}/ensenso_grabber.diff -d <SOURCE_DIR>)
endif()

ExternalProject_Add(
    pcl
    URL ${CACHED_URL}
    URL_HASH SHA256=5a102a2fbe2ba77c775bf92c4a5d2e3d8170be53a68c3a76cfc72434ff7b9783
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS ${PCL_DEPENDS}
    PATCH_COMMAND ${PCL_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${PCL_CMAKE_ARGS}
)
