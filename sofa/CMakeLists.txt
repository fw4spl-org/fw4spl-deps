cmake_minimum_required(VERSION 3.0)

project(sofaBuilder)

include(ExternalProject)

include(${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake)

set(SOFA_URL https://github.com/sofa-framework/sofa/archive/v17.12.02.tar.gz)
set(SOFA_HASHSUM dbcdb9a5f6c31778eb2a08bf040b9e575f3af2361e0fd488eb2fa1ec1fc992f2)

set(SOFA_MINIMAL_URL https://github.com/sofa-framework/sofa-minimal-poc/archive/d4546072dbbde77728a75f287aa7a1c69af5aa33.tar.gz)
set(SOFA_MINIMAL_HASHSUM 260f732e2a5ae349abbc4af8c0bf65fa83bbc1fc4b90db1c39e2b074610c507f)

set(SOFA_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(SOFA_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i${SOFA_PATCH_DIR}/v1712.patch -d <SOURCE_DIR>
           COMMAND "${PATCH_EXECUTABLE}" -p1 -i${SOFA_PATCH_DIR}/remove_eigen_sparse_matrix.diff -d <SOURCE_DIR>)

set(SOFA_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DPLUGIN_CIMGPLUGIN:BOOL=OFF
                    -DSOFA_FLOATING_POINT_TYPE:STRING=double
                    -DSOFA_BUILD_TESTS:BOOL=OFF
                    -DSOFA_REPO_SOURCE_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/sofa-sources-prefix/src/sofa-sources
                    -DSOFA_WITH_THREADING:BOOL=ON
                    -DPLUGIN_SOFAMINIMAL0:BOOL=ON
                    -DPLUGIN_SOFAMINIMAL1:BOOL=ON
                    -DPLUGIN_SOFAMINIMAL2:BOOL=ON
                    -DSOFA_NO_OPENGL:BOOL=OFF
                    -DEIGEN3_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include/eigen3
)

if(WIN32)
    # Grab compile definitions from fw-boost.cmake
    get_directory_property(SOFA_DEFINITIONS COMPILE_DEFINITIONS)
    foreach(DEF ${SOFA_DEFINITIONS})
        if(NOT ${DEF} STREQUAL "WIN32_LEAN_AND_MEAN")
            set(SOFA_CMAKE_CXX_FLAGS "/D${DEF} ${SOFA_CMAKE_CXX_FLAGS}")
        endif()
    endforeach()

    set(SOFA_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SOFA_CMAKE_CXX_FLAGS}")

    list(APPEND SOFA_CMAKE_ARGS
                -DCMAKE_CXX_FLAGS:STRING=${SOFA_CMAKE_CXX_FLAGS}
    )

    if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
        list(APPEND SOFA_CMAKE_ARGS -DPNG_LIBRARY_DEBUG:PATH=${CMAKE_INSTALL_PREFIX}/lib/libpng.lib
                                    -DGLUT_glut_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib/freeglutd.lib
        )
    else()
        list(APPEND SOFA_CMAKE_ARGS -DPNG_LIBRARY_RELEASE:PATH=${CMAKE_INSTALL_PREFIX}/lib/libpng.lib
                                    -DGLUT_glut_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib/freeglut.lib
        )
    endif()
endif()

find_package(OpenMP)
if(OPENMP_FOUND)
    list(APPEND SOFA_CMAKE_ARGS
                -DSOFA_OPENMP:BOOL=ON
        )
endif()

set(DEPENDENCIES eigen glew qt)
if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux) # Use system lib on linux.
    list(APPEND DEPENDENCIES libpng)
endif()

if(NOT APPLE)
    list(APPEND DEPENDENCIES freeglut)
else()
    list(APPEND SOFA_CMAKE_ARGS
                -DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework/GLUT
    )
endif()

# Original sources
ExternalProject_Add(
    sofa-sources
    URL ${SOFA_URL}
    URL_HASH SHA256=${SOFA_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${SOFA_PATCH_CMD}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

# New simpler build system
ExternalProject_Add(
    sofa
    URL ${SOFA_MINIMAL_URL}
    URL_HASH SHA256=${SOFA_MINIMAL_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME sofa-minimal-poc.tar.gz
    DEPENDS ${DEPENDENCIES} sofa-sources
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${SOFA_CMAKE_ARGS}
)

