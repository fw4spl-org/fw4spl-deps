cmake_minimum_required(VERSION 3.0)

project(arucoBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/aruco/archive/1.3.0.tar.gz)

set(ARUCO_CMAKE_ARGS    ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED_LIBS:BOOL=ON
                        -DINSTALL_DOC:BOOL=OFF
                        -DBUILD_UTILS:BOOL=OFF
                        -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
)

#seems to be not revelant since there is a fin_package(OpenMP in the aruco CMakeLists.txt)
if(ENABLE_OPEN_MP)
    find_package(OpenMP)
    if(OPENMP_FOUND)
        list(APPEND ARUCO_CMAKE_ARGS
             -DENABLE_OPENMP=ON
             )
    endif()
endif()

if(ANDROID)
    list(APPEND ARUCO_CMAKE_ARGS
         -DOpenCV_LIB_DIR="${CMAKE_INSTALL_PREFIX}/lib"
         )
else()

endif()

ExternalProject_Add(
    aruco
    URL ${CACHED_URL}
    URL_HASH SHA256=c53c58414af7de25a5e155588391be50e885d8ebb28da8ba22aaa656f4844ee0
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS opencv
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ARUCO_CMAKE_ARGS}
)

ExternalProject_Add_Step(aruco CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/lib/cmake/Findaruco.cmake ${CMAKE_INSTALL_PREFIX}/Findaruco.cmake
    COMMENT "Install Findaruco.cmake"
    DEPENDEES install
)
