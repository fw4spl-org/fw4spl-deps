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

set(CACHED_URL http://bullet.googlecode.com/files/bullet-2.82-r2704.tgz)

ExternalProject_Add(
    bullet
    URL ${CACHED_URL}
    URL_HASH SHA256=67e4c9eb76f7adf99501d726d8ad5e9b525dfd0843fbce9ca73aaca4ba9eced2
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${BULLET_CMAKE_ARGS}
)

ExternalProject_Add_Step(bullet CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindBullet.cmake ${CMAKE_INSTALL_PREFIX}/FindBullet.cmake
    COMMENT "Install configuration file"
)
