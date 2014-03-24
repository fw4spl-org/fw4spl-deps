CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(FreeType2)

SET(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" 
    CACHE PATH "Installation directory for executables")
SET(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" 
    CACHE PATH "Installation directory for libraries")
SET(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" 
    CACHE PATH "Installation directory for headers")

FIND_PACKAGE(zlib REQUIRED)
IF(NOT ZLIB_FOUND)
    MESSAGE(FATAL_ERROR "ZLIB not found !")
ENDIF()

ADD_DEFINITIONS(-DFT2_BUILD_LIBRARY)
ADD_DEFINITIONS("-DFT_CONFIG_MODULES_H=<ftmodule.h>")
ADD_DEFINITIONS(-DFT_CONFIG_OPTION_SYSTEM_ZLIB)

# Specify library include directories
INCLUDE_DIRECTORIES("${PROJECT_SOURCE_DIR}/builds/ansi")
INCLUDE_DIRECTORIES("${PROJECT_SOURCE_DIR}/include")
INCLUDE_DIRECTORIES("${PROJECT_SOURCE_DIR}/include/freetype")
INCLUDE_DIRECTORIES("${PROJECT_SOURCE_DIR}/include/freetype/config")

# For the auto-generated ftmodule.h file
INCLUDE_DIRECTORIES("${PROJECT_BINARY_DIR}/include")

INCLUDE_DIRECTORIES("${PROJECT_SOURCE_DIR}/objs")
INCLUDE_DIRECTORIES("${ZLIB_INCLUDE_DIRS}")

SET(BASE_SRCS
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

INCLUDE_DIRECTORIES("src/truetype")
INCLUDE_DIRECTORIES("src/sfnt")
INCLUDE_DIRECTORIES("src/autofit")
INCLUDE_DIRECTORIES("src/smooth")
INCLUDE_DIRECTORIES("src/raster")
INCLUDE_DIRECTORIES("src/psaux")
INCLUDE_DIRECTORIES("src/psnames")

IF(BUILD_SHARED_LIBS)
    IF(WIN32)
        ADD_LIBRARY(freetype SHARED ${BASE_SRCS} freetype.def)
    ELSE(WIN32)
        ADD_LIBRARY(freetype SHARED ${BASE_SRCS})
    ENDIF(WIN32)
    TARGET_LINK_LIBRARIES(freetype ${ZLIB_LIBRARIES})
ELSE(BUILD_SHARED_LIBS)
    ADD_LIBRARY(freetype STATIC ${BASE_SRCS})
ENDIF(BUILD_SHARED_LIBS)

INSTALL(TARGETS freetype
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )

INSTALL(DIRECTORY "${PROJECT_SOURCE_DIR}/include/freetype" DESTINATION "${INSTALL_INC_DIR}")
INSTALL(FILES "${PROJECT_SOURCE_DIR}/include/ft2build.h" DESTINATION "${INSTALL_INC_DIR}")
