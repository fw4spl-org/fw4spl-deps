cmake_minimum_required(VERSION 2.4.4)

project(zziplib C)

# Help cmake to look for zlib at the right place
set(ZLIB_ROOT ${CMAKE_INSTALL_PREFIX})

find_package(ZLIB REQUIRED)

INCLUDE_DIRECTORIES(${ZLIB_INCLUDE_DIRS})
SET(ZLIB_ZCONF_PATH ${ZLIB_INCLUDE_DIRS} CACHE PATH "")
INCLUDE_DIRECTORIES(${ZLIB_ZCONF_PATH})

set(VERSION "0.13.62")


if(MSVC)
    set(CMAKE_DEBUG_POSTFIX "d")
    set(ZZIP "zziplib")
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)
else()
    set(ZZIP "zzip")
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

#============================================================================
# zziplib
#============================================================================

# List the header files
set(HEADERS zzip/__debug.h
            zzip/__dirent.h
            zzip/__fnmatch.h
            zzip/__hints.h
            zzip/__mmap.h
            zzip/_config.h
            zzip/_msvc.h
            zzip/autoconf.h
            zzip/conf.h
            zzip/fetch.h
            zzip/file.h
            zzip/format.h
            zzip/fseeko.h
            zzip/info.h
            zzip/lib.h
            zzip/memdisk.h
            zzip/mmapped.h
            zzip/plugin.h
            zzip/stdint.h
            zzip/types.h
            zzip/write.h
            zzip/zzip.h
)

# List the source files
set(SRCS zzip/dir.c
         zzip/err.c
         zzip/fetch.c
         zzip/file.c
         zzip/info.c
         zzip/plugin.c
         zzip/stat.c
         zzip/zip.c
)
IF(BUILD_SHARED_LIBS)
    add_definitions(-DZZIP_EXPORTS)
    add_library(${ZZIP} SHARED ${SRCS} ${HEADERS})
ELSE(BUILD_SHARED_LIBS)
    add_library(${ZZIP} STATIC ${SRCS} ${HEADERS})
ENDIF(BUILD_SHARED_LIBS)

TARGET_LINK_LIBRARIES ( ${ZZIP}
        ${ZLIB_LIBRARIES}
)

INSTALL(TARGETS ${ZZIP}
        RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" 
        ARCHIVE DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" 
        LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"  )
INSTALL(FILES ${HEADERS} DESTINATION "${CMAKE_INSTALL_PREFIX}/include/zzip" )
