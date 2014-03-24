CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(dcmtkBuilder)

INCLUDE(ExternalProject)

SET(DCMTK_CMAKE_ARGS 
                        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                        -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX} 
                        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DDCMTK_WITH_XML:BOOL=ON
                        -DDCMTK_WITH_PNG:BOOL=ON
                        -DDCMTK_WITH_TIFF:BOOL=ON
                        -DDCMTK_WITH_OPENSSL:BOOL=OFF
                        -DDCMTK_WITH_ZLIB:BOOL=ON
                        -DDCMTK_WITH_DOXYGEN:BOOL=OFF
                        -DDCMTK_WITH_SNDFILE:BOOL=OFF
                        -DDCMTK_WITH_ICONV:BOOL=OFF
)

GET_CACHED_URL(http://dicom.offis.de/download/dcmtk/snapshot/old/dcmtk-3.6.1_20121102.tar.gz CACHED_URL)

#SET(GDCM_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

ExternalProject_Add(
    dcmtk
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    #PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${GDCM_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt" 
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${DCMTK_CMAKE_ARGS}
    DEPENDS tiff libpng 
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(dcmtk CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindDCMTK.cmake ${CMAKE_INSTALL_PREFIX}/FindDCMTK.cmake
    COMMENT "Install Configuration file"
)


