cmake_minimum_required(VERSION 3.0)

project(bulletBuilder)

include(ExternalProject)

set(BULLET_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DBUILD_CPU_DEMOS:BOOL=OFF
                      -DBUILD_DEMOS:BOOL=OFF
                      -DBUILD_EXTRAS:BOOL=OFF
                      -DBUILD_MINICL_OPENCL_DEMOS:BOOL=OFF
                      -DUSE_GLUT:BOOL=OFF
                      -DINSTALL_LIBS:BOOL=ON
                      -DUSE_MSVC_RUNTIME_LIBRARY_DLL:BOOL=ON
)

if(UNIX)
    list(APPEND BULLET_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON)
else(UNIX)
    list(APPEND BULLET_CMAKE_ARGS 
                -DCMAKE_DEBUG_POSTFIX:STRING=
                -DCMAKE_MINSIZEREL_POSTFIX:STRING=
    )
endif(UNIX)

set(CACHED_URL https://github.com/bulletphysics/bullet3/archive/2.86.1.tar.gz)


ExternalProject_Add(
    bullet
    URL ${CACHED_URL}
    URL_HASH SHA256=c058b2e4321ba6adaa656976c1a138c07b18fc03b29f5b82880d5d8228fbf059
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${BULLET_CMAKE_ARGS}
)

ExternalProject_Add_Step(bullet CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindBullet.cmake ${CMAKE_INSTALL_PREFIX}/FindBullet.cmake
    COMMENT "Install configuration file"
)
