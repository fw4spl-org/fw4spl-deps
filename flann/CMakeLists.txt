cmake_minimum_required(VERSION 3.0)

project(flannBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/mariusmuja/flann/archive/1.9.1.zip)

set(FLANN_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                     -DBUILD_EXAMPLES:BOOL=OFF
                     -DBUILD_DOC:BOOL=OFF
                     -DBUILD_TESTS:BOOL=OFF
                     -DBUILD_C_BINDINGS:BOOL=OFF
                     -DBUILD_MATLAB_BINDINGS:BOOL=OFF
                     -DBUILD_PYTHON_BINDINGS:BOOL=OFF
)

set(FLANN_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(FLANN_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i "${FLANN_PATCH_DIR}/flann_cmake_311.diff" -d "<SOURCE_DIR>")

ExternalProject_Add(
    flann
    URL ${CACHED_URL}
    URL_HASH SHA256=45420be368a76d1ea1d4337e8bd9b031d75a1abc01a1120a7ab9ea72a922e45f
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FLANN_CMAKE_ARGS}
    PATCH_COMMAND ${FLANN_PATCH_CMD}
)
