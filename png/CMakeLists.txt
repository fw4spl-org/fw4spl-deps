cmake_minimum_required(VERSION 3.0)

project(pngBuilder)

include(ExternalProject)

set(CACHED_URL http://freefr.dl.sourceforge.net/libpng/libpng-1.6.2.tar.gz)
set(PNG_CMAKE_ARGS  ${COMMON_CMAKE_ARGS}
                    -DPNG_DEBUG:BOOL=OFF
                    -DPNG_SHARED:BOOL=ON
                    -DPNG_TESTS:BOOL=OFF
)
set(LIBPNG_PATCH_CMD)
if(ANDROID)
    set(LIBPNG_PATCH_CMD COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_CURRENT_SOURCE_DIR}/patch/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt")
    
    list(APPEND PNG_CMAKE_ARGS 
        -DSKIP_INSTALL_LIBRARIES:BOOL=ON
        -DSKIP_INSTALL_EXECUTABLES:BOOL=ON
        -DSKIP_INSTALL_EXPORT:BOOL=ON
        -DSKIP_INSTALL_FILES:BOOL=ON
    )
elseif (UNIX)
    set(LIBPNG_PATCH_CMD COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_CURRENT_SOURCE_DIR}/patch/libpng-config.in" "<SOURCE_DIR>/libpng-config.in")
endif()

ExternalProject_Add(
        libpng
        DEPENDS zlib
        PATCH_COMMAND ${LIBPNG_PATCH_CMD}
        URL ${CACHED_URL}
        URL_HASH SHA256=516be5e8c4abfd688e6c73c14f74b523b9ef73be39751df514069cdf14b3be96
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${PNG_PATCH}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${PNG_CMAKE_ARGS}
)

if(${IS_DEBUG})
    set(LIBPNG_LIB_NAME "libpng16d")
else(${IS_DEBUG})
    set(LIBPNG_LIB_NAME "libpng16")
endif(${IS_DEBUG})
set(LIBPNG_LIB_NAME ${LIBPNG_LIB_NAME} PARENT_SCOPE)

if(WIN32)
    ExternalProject_Add_Step(libpng RENAME_LIBPNG
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBPNG_LIB_NAME}.lib libpng.lib 
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBPNG_LIB_NAME}.lib png.lib 
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )
elseif(CMAKE_HOST_WIN32)
    ExternalProject_Add_Step(libpng RENAME_LIBPNG
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBPNG_LIB_NAME}.so libpng.so 
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
        )
endif()

