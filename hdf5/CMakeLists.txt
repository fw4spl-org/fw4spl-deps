CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(hdf5Builder)

INCLUDE(ExternalProject)

SET(HDF5_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DHDF5_BUILD_CPP_LIB:BOOL=ON
                    -DHDF5_BUILD_HL_LIB:BOOL=OFF
                    -DHDF5_ENABLE_THREADSAFE:BOOL=ON
                    #-DHDF5_ENABLE_ZLIB_SUPPORT:BOOL=ON
)

GET_CACHED_URL(http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.9/src/hdf5-1.8.9.tar.gz CACHED_URL)


if( NOT WIN32 )
    #Case mistake in hdf5's cmakelists
    if(NOT EXISTS "${PROJECT_BINARY_DIR}/hdf5-prefix/src/hdf5/release_docs/Using_CMake.txt")
        set(PATCH PATCH_COMMAND cp
            ${PROJECT_BINARY_DIR}/hdf5-prefix/src/hdf5/release_docs/USING_CMake.txt
            ${PROJECT_BINARY_DIR}/hdf5-prefix/src/hdf5/release_docs/Using_CMake.txt
            || true
            )
    endif()
endif()

ExternalProject_Add(
    hdf5
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    ${PATCH}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${HDF5_CMAKE_ARGS}
)

