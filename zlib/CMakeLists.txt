CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(zlibBuilder)

INCLUDE(ExternalProject)

SET(ZLIB_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})

GET_CACHED_URL(http://zlib.net/zlib-1.2.8.tar.gz CACHED_URL)

ExternalProject_Add(
    zlib
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ZLIB_CMAKE_ARGS}
)

IF(WIN32)
    IF(${IS_DEBUG})
        SET(ZLIB_LIB_NAME "zlibd" PARENT_SCOPE)
    ELSE()
        SET(ZLIB_LIB_NAME "zlib" PARENT_SCOPE)
    ENDIF()
ELSE()
    SET(ZLIB_LIB_NAME "z" PARENT_SCOPE)
ENDIF()

IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC")
ENDIF()

IF(WIN32)
    IF(${IS_DEBUG})
        SET(RENAME_ZLIB_CMD ${CMAKE_COMMAND} -E copy_if_different zlibd.lib zdll.lib
                            COMMAND ${CMAKE_COMMAND} -E copy_if_different zlibd.lib zlib.lib)
    ELSE()
        SET(RENAME_ZLIB_CMD ${CMAKE_COMMAND} -E copy_if_different zlib.lib zdll.lib)
    ENDIF()

    ExternalProject_Add_Step(zlib RENAME_ZLIB
        COMMAND ${RENAME_ZLIB_CMD}
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )
ENDIF()
