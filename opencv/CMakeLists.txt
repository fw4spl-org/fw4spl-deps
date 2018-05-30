cmake_minimum_required(VERSION 3.0)

project(opencvBuilder)

include(ExternalProject)

set(ENABLE_OPENCV_NONFREE OFF CACHE BOOL "Choose whether non-free modules should be build")

set(OPENCV_CMAKE_ARGS
    ${COMMON_CMAKE_ARGS}
    -DENABLE_CXX11:BOOL=ON
    -DBUILD_DOCS:BOOL=OFF
    -DBUILD_TESTS:BOOL=OFF
    -DBUILD_PERF_TESTS:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_WITH_DEBUG_INFO:BOOL=OFF
    -DBUILD_opencv_apps:BOOL=OFF

    -DWITH_JASPER:BOOL=OFF #jpeg2k support
    -DWITH_1394:BOOL=OFF
    -DWITH_OPENEXR:BOOL=OFF
    -DWITH_OPENCL:BOOL=OFF

    -DWITH_JPEG:BOOL=ON
    -DWITH_PNG:BOOL=ON
    -DWITH_VTK:BOOL=OFF
    -DWITH_OPENGL:BOOL=ON
    -DWITH_TBB:BOOL=OFF
    -DWITH_TIFF:BOOL=ON
    -DWITH_ZLIB:BOOL=ON
    -DWITH_IPP:BOOL=OFF

    -DBUILD_JPEG:BOOL=OFF
    -DBUILD_PNG:BOOL=OFF
    -DBUILD_TIFF:BOOL=OFF
    -DBUILD_ZLIB:BOOL=OFF
    -DBUILD_opencv_java:BOOL=OFF
    -DBUILD_opencv_python:BOOL=OFF
    # Doesn't compile with Clang >= 3.5
    -DBUILD_opencv_ts:BOOL=OFF
    -DBUILD_opencv_dnn:BOOL=OFF
    -DBUILD_PROTOBUF:BOOL=OFF

    # OpenCV_contrib module
    -DOPENCV_EXTRA_MODULES_PATH=${CMAKE_CURRENT_BINARY_DIR}/opencv_contrib/src/modules

    # Enable Aruco module
    -DBUILD_opencv_aruco:BOOL=ON

    -DBUILD_opencv_adas:BOOL=OFF
    -DBUILD_opencv_bgsegm:BOOL=OFF
    -DBUILD_opencv_bioinspired:BOOL=OFF
    -DBUILD_opencv_ccalib:BOOL=OFF
    -DBUILD_opencv_datasets:BOOL=OFF
    -DBUILD_opencv_face:BOOL=OFF
    -DBUILD_opencv_latentsvm:BOOL=OFF
    -DBUILD_opencv_line_descriptor:BOOL=OFF
    -DBUILD_opencv_optflow:BOOL=OFF
    -DBUILD_opencv_ovis:BOOL=OFF
    -DBUILD_opencv_reg:BOOL=OFF
    -DBUILD_opencv_rgbd:BOOL=OFF
    -DBUILD_opencv_saliency:BOOL=OFF
    -DBUILD_opencv_surface_matching:BOOL=OFF
    -DBUILD_opencv_text:BOOL=OFF
    -DBUILD_opencv_tracking:BOOL=OFF
    -DBUILD_opencv_ximgproc:BOOL=OFF
    -DBUILD_opencv_xobjdetect:BOOL=OFF
    -DBUILD_opencv_xphoto:BOOL=OFF
    -DBUILD_opencv_cvv:BOOL=OFF
    -DBUILD_opencv_dpm:BOOL=OFF
    -DBUILD_opencv_dnn_modern:BOOL=OFF
)

if(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    # RelWithDebInfo is not officially supported by OpenCV and might cause subtle and/or hard to debug issues.
    # Building in release is probably the best thing to do until OpenCV officially supports it, if ever.
    string(REPLACE "CMAKE_BUILD_TYPE=RelWithDebInfo" "CMAKE_BUILD_TYPE=Release" OPENCV_CMAKE_ARGS "${OPENCV_CMAKE_ARGS}")
endif()

if(ENABLE_CUDA)
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 6.0)
            message(WARNING "Your gcc version might not be supported by CUDA, please see http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html for compatibility.")
        endif()
    endif()
endif()

list(APPEND OPENCV_CMAKE_ARGS
    -DWITH_CUDA:BOOL=${ENABLE_CUDA}
)

if(ENABLE_OPENCV_NONFREE)

    message(WARNING "By activating opencv non-free modules you should be aware that modules contains algorithms that may be patented in some countries or have some other limitations on the use")
    list(APPEND OPENCV_CMAKE_ARGS

        #OpenCv non-free modules
        -DBUILD_opencv_xfeatures2d:BOOL=ON
    )
else()
    list(APPEND OPENCV_CMAKE_ARGS
        -DBUILD_opencv_xfeatures2d:BOOL=OFF
    )
endif()

set(OPENCV_PATCH_CMD)
set(OPENCV_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(OPENCV_DEPENDS libpng zlib tiff)
endif()

if(ENABLE_CUDA)
    if(WIN32)
        # Workaround error C1041
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /FS")
        list(APPEND OPENCV_CMAKE_ARGS
             -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
             -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=ON
        )
    endif()
    list(APPEND OPENCV_CMAKE_ARGS
         -DBUILD_CUDA_STUBS:BOOL=OFF
         -DCUDA_ARCH_BIN:STRING=${BINPKGS_CUDA_ARCHS}
         -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
        )
endif()


if(WIN32)
    list(APPEND OPENCV_CMAKE_ARGS
        -DWITH_DSHOW:BOOL=ON
        -DWITH_MSMF:BOOL=OFF #required MSVC_2012+
        -DWITH_GSTREAMER:BOOL=OFF
        -DWITH_FFMPEG:BOOL=OFF
        -DWITH_WEBP:BOOL=OFF
        )
    list(APPEND OPENCV_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${OPENCV_PATCH_DIR}/win_install.diff -d <SOURCE_DIR> )
elseif(NOT ANDROID) #linux
    if(APPLE)
        list(APPEND OPENCV_CMAKE_ARGS
            -DWITH_QUICKTIME:BOOL=OFF
            -DWITH_FFMPEG:BOOL=OFF
            -DBUILD_opencv_ts:BOOL=ON
            )
    else()
        list(APPEND OPENCV_CMAKE_ARGS
            #required ffmpeg or libav development packages: libavcodec-dev, libavformat-dev, libswscale-dev
            -DWITH_FFMPEG:BOOL=ON
            -DWITH_V4L:BOOL=ON
            -DWITH_GSTREAMER:BOOL=OFF
            )
        # Clang >= 3.8 is not supported by CUDA 7.5
        if(UNIX AND ${CMAKE_C_COMPILER_ID} STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.7)
            list(APPEND OPENCV_CMAKE_ARGS -DCUDA_HOST_COMPILER:PATH=/usr/bin/gcc
                                          -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF
            )
        endif()
        list(APPEND OPENCV_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${OPENCV_PATCH_DIR}/cuda_clang.diff -d <SOURCE_DIR> )

        # Patch needed because of Linux distributions that ship gst-plugins-bad linked with opencv 2.4
        # As soon as we play a video, the cv register types are erased by the system library
        # This patch hacks that problem but we can't ensure there are not other hidden troubles...
        list(APPEND OPENCV_PATCH_CMD COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${OPENCV_PATCH_DIR}/linux_version_conflict.diff -d <SOURCE_DIR> )
    endif()

else() #ANDROID
    set(ANDROID_ARCH_NAME arm)
    list(APPEND OPENCV_CMAKE_ARGS
        -DENABLE_PRECOMPILED_HEADERS=OFF
        -DBUILD_JPEG:BOOL=ON
        -DBUILD_ANDROID_EXAMPLES:BOOL=OFF
        -DBUILD_WITH_ANDROID_NDK:BOOL=ON
        -DWITH_QT:BOOL=OFF
    )
    list(APPEND OPENCV_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${OPENCV_PATCH_DIR}/android.diff -d <SOURCE_DIR> )
endif()

set(OPENCV_VERSION 3.4.0)
set(CACHED_URL https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz)
set(OPENCV_HASHSUM 678cc3d2d1b3464b512b084a8cca1fad7de207c7abdf2caa1fed636c13e916da)
set(OPENCV_NAME "opencv_${OPENCV_VERSION}.tar.gz")

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/scripts/opencvContrib.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/scripts/opencvContrib.cmake
    IMMEDIATE @ONLY
)

if(NOT ANDROID)
    if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
        list(APPEND OPENCV_DEPENDS jpeg)
    endif()
    list(APPEND OPENCV_DEPENDS qt)
    list(APPEND OPENCV_CMAKE_ARGS
        -DWITH_QT:BOOL=ON
    )
endif()

ExternalProject_Add(
    opencv
    URL ${CACHED_URL}
    URL_HASH SHA256=${OPENCV_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME ${OPENCV_NAME}
    DEPENDS ${OPENCV_DEPENDS}
    PATCH_COMMAND ${OPENCV_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${OPENCV_CMAKE_ARGS}
)

ExternalProject_Add_Step(opencv OpenCVContrib
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/scripts/opencvContrib.cmake
    DEPENDEES download
    DEPENDERS build
    COMMENT "Download opencv contribution repository"
)
