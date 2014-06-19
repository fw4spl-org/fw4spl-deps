CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(gdcmBuilder)

INCLUDE(ExternalProject)

SET(GDCM_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                    -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX} 
                    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
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
                    #-DGDCMV2_0_COMPATIBILITY::BOOL=ON # for GDCM2.2.0 to keep compatibility of origin 
)

GET_CACHED_URL(https://github.com/malaterre/GDCM/archive/v2.2.5.tar.gz CACHED_URL)

SET(GDCM_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
ExternalProject_Add(
    gdcm
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    # PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${GDCM_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt" 
    DEPENDS zlib expat libxml vtk #MacOS -> libxslt ?
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GDCM_CMAKE_ARGS}
)


