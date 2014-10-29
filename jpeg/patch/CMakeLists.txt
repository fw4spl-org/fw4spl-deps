cmake_minimum_required(VERSION 2.8.6)
project(jpeg C)

include(CheckIncludeFile)
check_include_file(stddef.h HAVE_STDDEF_H)
check_include_file(stdlib.h HAVE_STDLIB_H)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" 
    CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" 
    CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" 
    CACHE PATH "Installation directory for headers")

set(LIBJPEG_SYSDEP jmemnobs.c)

set(LIBJPEG_COMMON jaricom.c jcomapi.c jutils.c jerror.c jmemmgr.c)

set(LIBJPEG_CLIB
    jcapimin.c jcapistd.c jcarith.c  jctrans.c  jcparam.c 
    jdatadst.c jcinit.c   jcmaster.c jcmarker.c jcmainct.c 
    jcprepct.c jccoefct.c jccolor.c  jcsample.c jchuff.c 
    jcdctmgr.c jfdctfst.c jfdctflt.c jfdctint.c
)

set(LIBJPEG_DLIB
    jdapimin.c jdapistd.c jdarith.c  jdtrans.c  jdatasrc.c 
    jdmaster.c jdinput.c  jdmarker.c jdhuff.c   jdmainct.c 
    jdcoefct.c jdpostct.c jddctmgr.c jidctfst.c jidctflt.c 
    jidctint.c jdsample.c jdcolor.c  jquant1.c  jquant2.c 
    jdmerge.c
)

configure_file(jconfig.h.cmake jconfig.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(LIBJPEG_H
    jerror.h jmorecfg.h jpeglib.h cderror.h cdjpeg.h
    jdct.h jinclude.h jmemsys.h jpegint.h jversion.h
    transupp.h ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h
)
set(LIBJPEG_FILES 
    ${LIBJPEG_SYSDEP} ${LIBJPEG_COMMON} ${LIBJPEG_CLIB} 
    ${LIBJPEG_DLIB} ${LIBJPEG_H}
)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(LIBJPEG_FILES ${LIBJPEG_FILES} jpegdll.def)
endif()

add_library(jpeg SHARED ${LIBJPEG_FILES})

install(TARGETS jpeg
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
install(FILES ${LIBJPEG_H} DESTINATION "${INSTALL_INC_DIR}")
