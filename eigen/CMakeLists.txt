cmake_minimum_required(VERSION 3.0)

project(eigenBuilder)

include(ExternalProject)

set(CACHED_URL https://bitbucket.org/eigen/eigen/get/3.2.6.tar.gz)

set(EIGEN_CMAKE_ARGS    ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DEIGEN_TEST_NOQT:BOOL=ON
                        -DBUILD_TESTING:BOOL=ON
)

set(EIGEN_PATCH_CMD "")

if(ANDROID)
    list(APPEND EIGEN_CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DBUILD_TESTING:BOOL=OFF
    )
    
    set(EIGEN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    set(EIGEN_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/eigen-prefix/src/eigen)
    set(EIGEN_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${EIGEN_PATCH_DIR}/EigenTesting.diff -d <SOURCE_DIR>
        COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${EIGEN_PATCH_DIR}/EigenConfigureTesting.diff -d <SOURCE_DIR>
    )
endif()

set(EIGEN_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/eigen-prefix/src/eigen)

ExternalProject_Add(
    eigen
    URL ${CACHED_URL}
    URL_HASH SHA256=b6e14e15c77146d1608476644207941ff8542b546cdc81fc1fe5c9398e7fc957
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME eigen_3.2.6.tar.gz
    PATCH_COMMAND ${EIGEN_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${EIGEN_CMAKE_ARGS}
)

ExternalProject_Add_Step(eigen CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/eigen-prefix/src/eigen/cmake/FindEigen3.cmake ${CMAKE_INSTALL_PREFIX}/FindEigen.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
