cmake_minimum_required(VERSION 3.0)

project(eigenBuilder)

include(ExternalProject)

set(CACHED_URL https://bitbucket.org/eigen/eigen/get/3.3.4.tar.gz)

set(EIGEN_CMAKE_ARGS    ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DEIGEN_TEST_NOQT:BOOL=ON
                        -DBUILD_TESTING:BOOL=OFF
)

# TODO: remove this patch on the next upgrade: it is a commit from the eigen repository, but not yet released. 
set(EIGEN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(EIGEN_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${EIGEN_PATCH_DIR}/CMakeLists_disable_test.diff -d <SOURCE_DIR>)

if(ANDROID)
    list(APPEND EIGEN_CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DBUILD_TESTING:BOOL=OFF
    )
endif()

set(EIGEN_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/eigen-prefix/src/eigen)

ExternalProject_Add(
    eigen
    URL ${CACHED_URL}
    URL_HASH SHA256=4286e8f1fabbd74f7ec6ef8ef31c9dbc6102b9248a8f8327b04f5b68da5b05e1
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME eigen_3.3.4.tar.gz
    PATCH_COMMAND ${EIGEN_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${EIGEN_CMAKE_ARGS}
)

fwInstallFile(
    BINPKG eigen
    SRC ${CMAKE_CURRENT_BINARY_DIR}/eigen-prefix/src/eigen/cmake/FindEigen3.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindEigen.cmake
)
