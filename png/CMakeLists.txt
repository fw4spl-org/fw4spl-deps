CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(pngBuilder)

INCLUDE(ExternalProject)

SET(PNG_CMAKE_ARGS 
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DPNG_DEBUG:BOOL=OFF
    -DPNG_SHARED:BOOL=ON
    -DPNG_TESTS:BOOL=OFF
)

GET_CACHED_URL(http://freefr.dl.sourceforge.net/libpng/libpng-1.6.2.tar.gz CACHED_URL)

ExternalProject_Add(
    libpng
    DEPENDS zlib
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${PNG_CMAKE_ARGS}
)

IF(WIN32)
    IF(${IS_DEBUG})
        SET(LIBPNG_LIB_NAME "libpng16d")
    ELSE(${IS_DEBUG})
        SET(LIBPNG_LIB_NAME "libpng16")
    ENDIF(${IS_DEBUG})
        SET(LIBPNG_LIB_NAME ${LIBPNG_LIB_NAME} PARENT_SCOPE)

    ExternalProject_Add_Step(libpng RENAME_LIBPNG
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBPNG_LIB_NAME}.lib libpng.lib 
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBPNG_LIB_NAME}.lib png.lib 
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )

ELSE()
    SET(LIBPNG_LIB_NAME "png16" PARENT_SCOPE)
ENDIF()

