CMAKE_MINIMUM_REQUIRED(VERSION 2.8.6)
PROJECT(jpeg C)

INCLUDE(CheckIncludeFile)
check_include_file(stddef.h HAVE_STDDEF_H)
check_include_file(stdlib.h HAVE_STDLIB_H)

SET(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" 
    CACHE PATH "Installation directory for executables")
SET(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" 
    CACHE PATH "Installation directory for libraries")
SET(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" 
    CACHE PATH "Installation directory for headers")

SET(LIBJPEG_SYSDEP jmemnobs.c)

SET(LIBJPEG_COMMON jaricom.c jcomapi.c jutils.c jerror.c jmemmgr.c)

SET(LIBJPEG_CLIB
    jcapimin.c jcapistd.c jcarith.c  jctrans.c  jcparam.c 
    jdatadst.c jcinit.c   jcmaster.c jcmarker.c jcmainct.c 
    jcprepct.c jccoefct.c jccolor.c  jcsample.c jchuff.c 
    jcdctmgr.c jfdctfst.c jfdctflt.c jfdctint.c
)

SET(LIBJPEG_DLIB
    jdapimin.c jdapistd.c jdarith.c  jdtrans.c  jdatasrc.c 
    jdmaster.c jdinput.c  jdmarker.c jdhuff.c   jdmainct.c 
    jdcoefct.c jdpostct.c jddctmgr.c jidctfst.c jidctflt.c 
    jidctint.c jdsample.c jdcolor.c  jquant1.c  jquant2.c 
    jdmerge.c
)

CONFIGURE_FILE(jconfig.h.cmake jconfig.h)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})

SET(LIBJPEG_H
    jerror.h jmorecfg.h jpeglib.h cderror.h cdjpeg.h
    jdct.h jinclude.h jmemsys.h jpegint.h jversion.h
    transupp.h ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h
)
SET(LIBJPEG_FILES 
    ${LIBJPEG_SYSDEP} ${LIBJPEG_COMMON} ${LIBJPEG_CLIB} 
    ${LIBJPEG_DLIB} ${LIBJPEG_H}
)

IF(CMAKE_SYSTEM_NAME MATCHES "Windows")
    SET(LIBJPEG_FILES ${LIBJPEG_FILES} jpegdll.def)
ENDIF()

ADD_LIBRARY(jpeg SHARED ${LIBJPEG_FILES})

INSTALL(TARGETS jpeg
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
INSTALL(FILES ${LIBJPEG_H} DESTINATION "${INSTALL_INC_DIR}")
