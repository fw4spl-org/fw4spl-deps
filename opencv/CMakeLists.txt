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
    -DWITH_CUDA:BOOL=OFF
    -DWITH_OPENCL:BOOL=OFF

    -DWITH_JPEG:BOOL=ON
    -DWITH_PNG:BOOL=ON
    -DWITH_QT:BOOL=OFF
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
    )
endif()

set(OPENCV_PATCH_CMD)
set(OPENCV_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(OPENCV_DEPENDS libpng zlib tiff)

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
    list(APPEND OPENCV_CMAKE_ARGS
        -DENABLE_PRECOMPILED_HEADERS=OFF
        -DBUILD_JPEG:BOOL=ON
        -DBUILD_ANDROID_EXAMPLES:BOOL=OFF
    )
    list(APPEND OPENCV_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${OPENCV_PATCH_DIR}/android.diff -d <SOURCE_DIR> )
endif()

#Dowload opencv repository

set(CACHED_URL https://github.com/Itseez/opencv/archive/3.0.0.zip)

if(NOT ANDROID)
    list(APPEND OPENCV_DEPENDS jpeg )
endif()

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/scripts/opencvContrib.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/scripts/opencvContrib.cmake
    IMMEDIATE @ONLY
)

ExternalProject_Add(
    opencv
    URL ${CACHED_URL}
    URL_HASH SHA256=07094ea2f996f2622d572f0f3a162d698c8a547520341ca9109fbaf9363fb001
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME opencv_3.0.0.zip
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