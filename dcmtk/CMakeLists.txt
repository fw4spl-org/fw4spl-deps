cmake_minimum_required(VERSION 3.0)

project(dcmtkBuilder)

include(ExternalProject)

set(DCMTK_CMAKE_ARGS    ${COMMON_CMAKE_ARGS}
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

set(DCMTK_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(DCMTK_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${DCMTK_PATCH_DIR}/scp_scu.h.diff -d <SOURCE_DIR>)

# On Linux-gcc we have a crash on the first call to ::DcmSCP::addPresentationContext() only in debug
# This is weird but for now we keep the release version (with debug symbols)
if(UNIX AND NOT APPLE AND NOT ${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang" AND ${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    list(APPEND DCMTK_CMAKE_ARGS -DCMAKE_BUILD_TYPE=RelWithDebInfo)
endif()

set(CACHED_URL http://dicom.offis.de/download/dcmtk/snapshot/old/dcmtk-3.6.1_20150217.tar.gz)
set(DCMTK_HASHSUM 3cf8f3e52ed8a5240a7facc3a118de411aa54bc9beccba0cf7a975735da35304)

if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(DCMTK_DEPENDS tiff libpng libxml)
endif()

ExternalProject_Add(
    dcmtk
    URL ${CACHED_URL}
    URL_HASH SHA256=${DCMTK_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${DCMTK_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${DCMTK_CMAKE_ARGS}
    DEPENDS ${DCMTK_DEPENDS}
)

fwInstallFile(
    BINPKG dcmtk
    SRC ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-DCMTK.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/fw-DCMTK.cmake
)
