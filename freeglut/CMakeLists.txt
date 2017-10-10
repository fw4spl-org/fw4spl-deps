cmake_minimum_required(VERSION 3.0)

project(freeGLUTBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/dcnieho/FreeGLUT/archive/FG_3_0_0_RC2.tar.gz)

set(FREEGLUT_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DINSTALL_PDB:BOOL=OFF
                      -DFREEGLUT_BUILD_STATIC_LIBS:BOOL=OFF
                      -DFREEGLUT_REPLACE_GLUT:BOOL=ON
                      -DFREEGLUT_BUILD_DEMOS:BOOL=OFF
)

ExternalProject_Add(
    freeglut
    URL ${CACHED_URL}
    URL_HASH SHA256=c377562a3cfda117a28dd23682992183b0a49e6241db803ab7d56bd644ad7f7d
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${FREEGLUT_CMAKE_ARGS}
)

if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
        set(FREEGLUT_LIBNAME freeglutd.lib)
    else()
        set(FREEGLUT_LIBNAME freeglut.lib)
    endif()
    ExternalProject_Add_Step(freeglut RENAME_FREEGLUT
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${FREEGLUT_LIBNAME} glut32.lib
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
    )
endif()
