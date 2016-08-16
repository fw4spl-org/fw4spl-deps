cmake_minimum_required(VERSION 3.0)

project(glewBuilder)

include(ExternalProject)

set(CACHED_URL http://sourceforge.net/projects/glew/files/glew/1.12.0/glew-1.12.0.tgz/download)

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
    URL_HASH SHA256=af58103f4824b443e7fa4ed3af593b8edac6f3a7be3b30911edbc7344f48e4bf
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${GLEW_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GLEW_CMAKE_ARGS}
)


