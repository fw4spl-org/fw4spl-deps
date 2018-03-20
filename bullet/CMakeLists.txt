cmake_minimum_required(VERSION 3.0)

project(bulletBuilder)

include(ExternalProject)

set(BULLET_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DINSTALL_LIBS:BOOL=ON
                      -DUSE_MSVC_RUNTIME_LIBRARY_DLL:BOOL=ON
                      -DBUILD_OPENGL3_DEMOS:BOOL=OFF
                      -DBUILD_BULLET2_DEMOS:BOOL=OFF
                      -DBULLET2_MULTITHREADED_OPEN_MP_DEMO:BOOL=OFF
                      -DBULLET2_MULTITHREADED_TBB_DEMO:BOOL=OFF
                      -DBULLET2_MULTITHREADED_PPL_DEMO:BOOL=OFF
                      -DBUILD_CPU_DEMOS:BOOL=OFF
                      -DUSE_GLUT:BOOL=OFF 
                      -DBUILD_UNIT_TESTS:BOOL=OFF
)

if(UNIX)
    list(APPEND BULLET_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON)
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

fwInstallFile(
    BINPKG bullet
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindBullet.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindBullet.cmake
)
