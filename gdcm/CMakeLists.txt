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
                    # Do not build man pages, troubles were reported on MacOsX
                    # https://github.com/fw4spl-org/fw4spl/issues/8
                    -DGDCM_BUILD_DOCBOOK_MANPAGES:BOOL=OFF
                    -DUSE_ITK:BOOL=OFF
)

set(CACHED_URL https://github.com/malaterre/GDCM/archive/v2.6.7.tar.gz)

# Needed for windows to find our zlib but doesn't hurt on other platforms
set(GDCM_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(GDCM_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${GDCM_PATCH_DIR}/zlib.diff -d <SOURCE_DIR>
                    && "${PATCH_EXECUTABLE}" -p1 -i ${GDCM_PATCH_DIR}/fixVTKOverload.diff -d <SOURCE_DIR>)

ExternalProject_Add(
    gdcm
    URL ${CACHED_URL}
    URL_HASH SHA256=b8d57a3ea3464dac34252ef1cd816d9f4b61911ca9e94a74552d907ec406a579
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS vtk
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GDCM_CMAKE_ARGS}
    PATCH_COMMAND ${GDCM_PATCH_CMD}
)


