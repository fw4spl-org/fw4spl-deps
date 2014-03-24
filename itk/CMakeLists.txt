CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(itkBuilder)

INCLUDE(ExternalProject)

SET(ITK_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                   -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX} 
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DBUILD_EXAMPLES:BOOL=OFF
                   -DBUILD_SHARED_LIBS:BOOL=ON
                   -DBUILD_TESTING:BOOL=OFF
                   -DBUILD_DOXYGEN:BOOL=OFF
                   -DITK_USE_SYSTEM_GDCM:BOOL=ON
                   -DITK_USE_SYSTEM_LIBXML2:BOOL=ON
                   -DITK_USE_SYSTEM_PNG:BOOL=ON
                   -DITK_USE_SYSTEM_TIFF:BOOL=ON
                   -DITK_USE_SYSTEM_VXL:BOOL=ON
                   -DITK_USE_SYSTEM_ZLIB:BOOL=ON
                   -DBUILD_DOXYGEN:BOOL=OFF
                   -DITK_USE_REVIEW:BOOL=ON
                   -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON
)


IF(APPLE)
    SET(ITK_PATCH_CMD && patch -t -N -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/patch/osx-10.9-no-itkTestDriver.patch
                      && patch -t -N -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/patch/osx-10.9-std-abs-issue.patch )
ENDIF()

GET_CACHED_URL(http://freefr.dl.sourceforge.net/project/itk/itk/3.20/InsightToolkit-3.20.1.tar.gz CACHED_URL)
SET(ITK_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

ExternalProject_Add(
    itk
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${ITK_PATCH_DIR}/" "<SOURCE_DIR>/" ${ITK_PATCH_CMD}
    DEPENDS zlib jpeg libpng tiff libxml vxl gdcm vtk
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ITK_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(itk CopyConfigFileToInstall 
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-ITK.cmake ${CMAKE_INSTALL_PREFIX}/fw-ITK.cmake
    COMMENT "Install configuration file"
)
