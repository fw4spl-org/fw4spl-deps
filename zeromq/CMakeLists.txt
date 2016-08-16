cmake_minimum_required(VERSION 3.0)

PROJECT(zeromqBuilder)

INCLUDE(ExternalProject)

set(CACHED_URL https://github.com/zeromq/zeromq4-x/archive/v4.0.5.tar.gz)

set(ZEROMQ_CMAKE_ARGS ${COMMON_CMAKE_ARGS} )

if(WIN32)
    list(APPEND ZEROMQ_CMAKE_ARGS
        -DBUILD_SHARED:BOOL=ON
        )
endif()

set(ZEROMQ_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(ZMQ_PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/CMakeLists.txt.diff -d <SOURCE_DIR>)

ExternalProject_Add(
    zeromq
    URL ${CACHED_URL}
    URL_HASH SHA256=e3dc99aeacd4e1e7a025f22f92afec6c381b82f0e29222d27e1256ada841e43f
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME zeromq_v4.0.5.tar.gz
    PATCH_COMMAND ${ZMQ_PATCH_COMMAND}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ZEROMQ_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(zeromq CPP_ZEROMQ
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${ZEROMQ_PATCH_DIR}/cpp-zeromq ${CMAKE_INSTALL_PREFIX}/include/
        DEPENDEES build
        DEPENDERS install
    )


ExternalProject_Add_Step(zeromq CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindZEROMQ.cmake ${CMAKE_INSTALL_PREFIX}/FindZEROMQ.cmake
    COMMENT "Install configuration file"
)

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fPIC")
endif()
