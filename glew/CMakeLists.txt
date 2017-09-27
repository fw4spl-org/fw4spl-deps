cmake_minimum_required(VERSION 3.0)

project(glewBuilder)

include(ExternalProject)

set(CACHED_URL http://sourceforge.net/projects/glew/files/glew/2.0.0/glew-2.0.0.tgz/download https://github.com/nigels-com/glew/releases/download/glew-2.0.0/glew-2.0.0.tgz )

set(GLEW_CMAKE_ARGS ${COMMON_CMAKE_ARGS} 
        -DGLEW_MX:BOOL=OFF 
        -DBUILD_SHARED_LIBS:BOOL=ON
    )

set(GLEW_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(GLEW_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/glew-prefix/src/glew)
set(GLEW_PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different "${GLEW_PATCH_DIR}/CMakeLists.txt" "${GLEW_SRC_DIR}/CMakeLists.txt")

ExternalProject_Add(
    glew
    URL ${CACHED_URL}
    URL_HASH SHA256=c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${GLEW_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GLEW_CMAKE_ARGS}
)


