cmake_minimum_required(VERSION 3.0)

project(sofaBuilder)

include(ExternalProject)

include(${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake)

set(CACHED_URL https://github.com/sofa-framework/sofa/archive/v17.06.02.tar.gz)
set(SOFA_HASHSUM 1f7f2c00f87570b29c40db34145acb385da4b2db6173d0f6cd61b25e887dc168)

set(SOFA_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(SOFA_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i${SOFA_PATCH_DIR}/missing_headers.diff -d <SOURCE_DIR>
           COMMAND "${PATCH_EXECUTABLE}" -p1 -i${SOFA_PATCH_DIR}/windows_pack.diff -d <SOURCE_DIR>
           COMMAND "${PATCH_EXECUTABLE}" -p1 -i${SOFA_PATCH_DIR}/libpng_pragma.diff -d <SOURCE_DIR>
           COMMAND "${PATCH_EXECUTABLE}" -p1 -i${SOFA_PATCH_DIR}/winimport.diff -d <SOURCE_DIR>
           COMMAND "${PATCH_EXECUTABLE}" -p1 -i${SOFA_PATCH_DIR}/no_dependencies_install.diff -d <SOURCE_DIR>
           COMMAND "${PATCH_EXECUTABLE}" --binary -p1 -i${SOFA_PATCH_DIR}/remove_embedded_eigen.diff -d <SOURCE_DIR>
)

set(SOFA_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DPLUGIN_CIMGPLUGIN:BOOL=OFF
                    -DSOFA_FLOATING_POINT_TYPE:STRING=double
                    -DSOFA_BUILD_TESTS:BOOL=OFF
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

set(DEPENDENCIES eigen boost glew qt)
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

ExternalProject_Add(
    sofa
    URL ${CACHED_URL}
    URL_HASH SHA256=${SOFA_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME sofa-v17.06.02.tar.gz
    PATCH_COMMAND ${SOFA_PATCH_CMD}
    DEPENDS ${DEPENDENCIES}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${SOFA_CMAKE_ARGS}
)
