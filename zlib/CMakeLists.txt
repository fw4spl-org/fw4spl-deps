cmake_minimum_required(VERSION 2.8)

project(zlibBuilder)

include(ExternalProject)

set(ZLIB_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})

getCachedUrl(http://zlib.net/zlib-1.2.8.tar.gz CACHED_URL)

ExternalProject_Add(
    zlib
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ZLIB_CMAKE_ARGS}
)

if(WIN32)
    if(${IS_DEBUG})
        set(ZLIB_LIB_NAME "zlibd" PARENT_SCOPE)
    else()
        set(ZLIB_LIB_NAME "zlib" PARENT_SCOPE)
    endif()
else()
    set(ZLIB_LIB_NAME "z" PARENT_SCOPE)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC")
endif()

if(WIN32)
    if(${IS_DEBUG})
        set(RENAME_ZLIB_CMD ${CMAKE_COMMAND} -E copy_if_different zlibd.lib zdll.lib
                            COMMAND ${CMAKE_COMMAND} -E copy_if_different zlibd.lib zlib.lib)
    else()
        set(RENAME_ZLIB_CMD ${CMAKE_COMMAND} -E copy_if_different zlib.lib zdll.lib)
    endif()

    ExternalProject_Add_Step(zlib RENAME_ZLIB
        COMMAND ${RENAME_ZLIB_CMD}
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )
endif()
