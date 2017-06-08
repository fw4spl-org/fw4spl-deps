cmake_minimum_required(VERSION 3.0)

project(opencvBuilder)

include(ExternalProject)

set(ENABLE_OPENCV_CONTRIB OFF CACHE BOOL "Choose whether openCV_contrib extra modules should be build")

set(OPENCV_CMAKE_ARGS
    ${COMMON_CMAKE_ARGS}
    -DBUILD_DOCS:BOOL=OFF
    -DBUILD_TESTS:BOOL=OFF
    -DBUILD_PERF_TESTS:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_WITH_DEBUG_INFO:BOOL=OFF

    -DWITH_JASPER:BOOL=OFF #jpeg2k support
    -DWITH_1394:BOOL=OFF
    -DWITH_OPENEXR:BOOL=OFF
    -DWITH_CUDA:BOOL=${FW4SPL_OPENCV_WITH_CUDA}
    -DWITH_OPENCL:BOOL=OFF

    -DWITH_JPEG:BOOL=ON
    -DWITH_PNG:BOOL=ON
    -DWITH_VTK:BOOL=OFF
    -DWITH_OPENGL:BOOL=ON
    -DWITH_TBB:BOOL=OFF
    -DWITH_TIFF:BOOL=ON
    -DWITH_ZLIB:BOOL=ON

    -DBUILD_JPEG:BOOL=OFF
    -DBUILD_PNG:BOOL=OFF
    -DBUILD_TIFF:BOOL=OFF
    -DBUILD_ZLIB:BOOL=OFF
    -DBUILD_opencv_java:BOOL=OFF
    -DBUILD_opencv_python:BOOL=OFF
    # Doesn't compile with Clang >= 3.5
    -DBUILD_opencv_ts:BOOL=OFF
)

if(ENABLE_OPENCV_CONTRIB)
    list(APPEND OPENCV_CMAKE_ARGS

        -DOPENCV_EXTRA_MODULES_PATH=${CMAKE_CURRENT_BINARY_DIR}/opencv_contrib/src/modules

        #OpenCv_contrib module
        -DBUILD_opencv_xfeatures2d:BOOL=ON

        -DBUILD_opencv_adas:BOOL=OFF
        -DBUILD_opencv_bgsegm:BOOL=OFF
        -DBUILD_opencv_bioinspired:BOOL=OFF
        -DBUILD_opencv_ccalib:BOOL=OFF
        -DBUILD_opencv_datasets:BOOL=OFF
        -DBUILD_opencv_face:BOOL=OFF
        -DBUILD_opencv_latentsvm:BOOL=OFF
        -DBUILD_opencv_line_descriptor:BOOL=OFF
        -DBUILD_opencv_optflow:BOOL=OFF
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
        -DBUILD_opencv_aruco:BOOL=OFF
    )
endif()

set(OPENCV_PATCH_CMD)
set(OPENCV_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(OPENCV_DEPENDS libpng zlib tiff)

if(ENABLE_OPENCV_CUDA)
    if(WIN32)
        # Fix link error with the MSVC compiler (fixed upstream in c4a3478)
        list(APPEND OPENCV_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${OPENCV_PATCH_DIR}/CUDA_link_VS.diff -d <SOURCE_DIR> )
        # Workaround error C1041
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /FS")
        list(APPEND OPENCV_CMAKE_ARGS
             -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
             -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=ON
        )
    endif()
    list(APPEND OPENCV_CMAKE_ARGS
         -DBUILD_CUDA_STUBS:BOOL=OFF
         -DWITH_CUDA:BOOL=ON
         -DCUDA_ARCH_BIN:STRING=${FW4SPL_CUDA_ARCHS}
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

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/scripts/opencvContrib.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/scripts/opencvContrib.cmake
    IMMEDIATE @ONLY
)

if(NOT ANDROID)
    list(APPEND OPENCV_DEPENDS jpeg qt)
    list(APPEND OPENCV_CMAKE_ARGS
        -DWITH_QT:BOOL=ON
    )
endif()

set(OPENCV_HASHSUM b9d62dfffb8130d59d587627703d5f3e6252dce4a94c1955784998da7a39dd35)
set(OPENCV_NAME "opencv_3.2.0.tar.gz")
set(CACHED_URL https://github.com/opencv/opencv/archive/3.2.0.tar.gz)

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

if(ENABLE_OPENCV_CONTRIB)
    ExternalProject_Add_Step(opencv OpenCVContrib
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/scripts/opencvContrib.cmake
        DEPENDEES download
        DEPENDERS build
        COMMENT "Download opencv contribution repository"
    )
endif()
