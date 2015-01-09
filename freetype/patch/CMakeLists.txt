cmake_minimum_required(VERSION 2.8)

project(FreeType2)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" 
    CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" 
    CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" 
    CACHE PATH "Installation directory for headers")

find_package(ZLIB REQUIRED)
if(NOT ZLIB_FOUND)
    message(FATAL_ERROR "ZLIB not found !")
endif()

add_definitions(-DFT2_BUILD_LIBRARY)
add_definitions("-DFT_CONFIG_MODULES_H=<ftmodule.h>")
add_definitions(-DFT_CONFIG_OPTION_SYSTEM_ZLIB)

# Specify library include directories
include_directories("${PROJECT_SOURCE_DIR}/builds/ansi")
include_directories("${PROJECT_SOURCE_DIR}/include")
include_directories("${PROJECT_SOURCE_DIR}/include/freetype")
include_directories("${PROJECT_SOURCE_DIR}/include/freetype/config")

# For the auto-generated ftmodule.h file
include_directories("${PROJECT_BINARY_DIR}/include")

include_directories("${PROJECT_SOURCE_DIR}/objs")
include_directories("${ZLIB_INCLUDE_DIRS}")

set(BASE_SRCS
    src/base/ftsystem.c
    src/base/ftdebug.c
    src/base/ftinit.c
    src/base/ftbbox.c
    src/base/ftbitmap.c
    src/base/ftcid.c
    src/base/ftadvanc.c
    src/base/ftcalc.c
    src/base/ftdbgmem.c
    src/base/ftgloadr.c
    src/base/ftobjs.c
    src/base/ftoutln.c
    src/base/ftrfork.c
    src/base/ftsnames.c
    src/base/ftstream.c
    src/base/fttrigon.c
    src/base/ftutil.c
    src/base/ftfstype.c
    src/base/ftgasp.c
    src/base/ftglyph.c
    src/base/ftgxval.c
    src/base/ftlcdfil.c
    src/base/ftmm.c
    src/base/ftotval.c
    src/base/ftpatent.c
    src/base/ftpfr.c
    src/base/ftstroke.c
    src/base/ftsynth.c
    src/base/fttype1.c
    src/base/ftwinfnt.c
    src/base/ftxf86.c
    src/truetype/truetype.c
    src/type1/type1.c
    src/cff/cff.c
    src/cid/type1cid.c
    src/pfr/pfr.c
    src/type42/type42.c
    src/winfonts/winfnt.c
    src/pcf/pcf.c
    src/bdf/bdf.c
    src/sfnt/sfnt.c
    src/autofit/autofit.c
    src/pshinter/pshinter.c
    src/raster/raster.c
    src/smooth/smooth.c
    src/cache/ftcache.c
    src/gzip/ftgzip.c
    src/lzw/ftlzw.c
    src/bzip2/ftbzip2.c
    src/psaux/psaux.c
    src/psnames/psmodule.c)

include_directories("src/truetype")
include_directories("src/sfnt")
include_directories("src/autofit")
include_directories("src/smooth")
include_directories("src/raster")
include_directories("src/psaux")
include_directories("src/psnames")

if(BUILD_SHARED_LIBS)
    if(WIN32)
        add_library(freetype SHARED ${BASE_SRCS} freetype.def)
    else(WIN32)
        add_library(freetype SHARED ${BASE_SRCS})
    endif(WIN32)
    target_link_libraries(freetype ${ZLIB_LIBRARIES})
else(BUILD_SHARED_LIBS)
    add_library(freetype STATIC ${BASE_SRCS})
endif(BUILD_SHARED_LIBS)

install(TARGETS freetype
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )

install(DIRECTORY "${PROJECT_SOURCE_DIR}/include/freetype" DESTINATION "${INSTALL_INC_DIR}")
install(FILES "${PROJECT_SOURCE_DIR}/include/ft2build.h" DESTINATION "${INSTALL_INC_DIR}")
