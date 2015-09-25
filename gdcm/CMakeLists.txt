cmake_minimum_required(VERSION 3.0)

project(gdcmBuilder)

include(ExternalProject)

set(GDCM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DGDCM_USE_VTK:BOOL=ON
                    -DGDCM_BUILD_SHARED_LIBS:BOOL=ON
                    -DGDCM_USE_SYSTEM_ZLIB:BOOL=ON
                    -DGDCM_USE_SYSTEM_EXPAT:BOOL=ON
                    #-DGDCM_USE_SYSTEM_LJPEG:BOOL=ON    #Lossless JPEG
                    #-DGDCM_USE_SYSTEM_OPENJPEG:BOOL=ON #Open-source C-Library for JPEG 2000
                    -DGDCM_WRAP_PYTHON:BOOL=OFF
                    -DGDCM_DOCUMENTATION:BOOL=OFF
                    -DGDCM_BUILD_TESTING:BOOL=OFF
                    -DGDCM_BUILD_EXAMPLES:BOOL=OFF
                    -DGDCM_BUILD_APPLICATIONS:BOOL=OFF
                    -DGDCM_USE_WXWIDGETS:BOOL=OFF
                    -DUSE_ITK:BOOL=OFF
)

set(CACHED_URL https://github.com/malaterre/GDCM/archive/v2.4.2.tar.gz)

set(GDCM_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(GDCM_PATCH_CMD ${CMAKE_COMMAND} -E  copy_if_different "${GDCM_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${GDCM_PATCH_DIR}/VTK/CMakeLists.txt" "<SOURCE_DIR>/Utilities/VTK/CMakeLists.txt")

ExternalProject_Add(
    gdcm
    URL ${CACHED_URL}
    URL_HASH SHA256=e3577255032013dfb9a8799c2a8f278a6de759072dcb5ef54f4c470eb00c5bf3
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME gdcm-2.4.2.tar.gz
    PATCH_COMMAND ${GDCM_PATCH_CMD}
    DEPENDS zlib expat libxml vtk
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GDCM_CMAKE_ARGS}
)


