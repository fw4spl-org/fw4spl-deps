cmake_minimum_required(VERSION 2.8)

project(CXSparseBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/PetterS/CXSparse/archive/80a69763edae3aa445667df9915fd7ff163e1127.tar.gz)

set(CXSPARSE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(CXSPARSE_PATCH_CMD ${CMAKE_COMMAND} -E  copy_if_different "${CXSPARSE_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${CXSPARSE_PATCH_DIR}/Demo/CMakeLists.txt" "<SOURCE_DIR>/Demo/CMakeLists.txt"
    COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CXSPARSE_PATCH_DIR}/SuiteSparse_config.h.diff -d <SOURCE_DIR>
    COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CXSPARSE_PATCH_DIR}/cs_convert.c.diff -d <SOURCE_DIR>
)

set(CXSPARSE_CMAKE_ARGS ${COMMON_CMAKE_ARGS})

if(NOT WIN32)
    list(APPEND CXSPARSE_CMAKE_ARGS 
                -DBUILD_SHARED_LIBS:BOOL=ON
                -DCMAKE_BUILD_TYPE=Release) #Force Release for performance
else()
    list(APPEND CXSPARSE_CMAKE_ARGS 
                -DBUILD_SHARED_LIBS:BOOL=OFF)
endif()

ExternalProject_Add(
        CXSparse
        URL ${CACHED_URL}
        URL_HASH SHA256=e7b989d8d3c2fcdcc813a90a87618c713e4472f544e97a62d451e97080cd9185
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DOWNLOAD_NAME CXSparse.tar.gz
        PATCH_COMMAND ${CXSPARSE_PATCH_CMD}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${CXSPARSE_CMAKE_ARGS}
)
