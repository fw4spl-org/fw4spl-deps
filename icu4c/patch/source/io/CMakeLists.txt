cmake_minimum_required(VERSION 2.8)

PROJECT(icuio)

INCLUDE_DIRECTORIES(
    ../common
    ../i18n
)

SET (ICUIO_SOURCE_FILES
    locbund.cpp
    sprintf.c
    sscanf.c
    ucln_io.c
    ufile.c
    ufmt_cmn.c
    uprintf.c
    uprntf_p.c
    uscanf.c
    uscanf_p.c
    ustdio.c
    ustream.cpp
)

SET(ICUIO_HEADER_FILES
    locbund.h
    ucln_io.h
    ufile.h
    ufmt_cmn.h
    uprintf.h
    uscanf.h
)

SOURCE_GROUP("Source Files" FILES ${ICUIO_SOURCE_FILES})
SOURCE_GROUP("Header Files" FILES ${ICUIO_HEADER_FILES})

SET_SOURCE_FILES_PROPERTIES(ICUIO_HEADER_FILES
                            PROPERTIES HEADER_FILE_ONLY TRUE)
LIST(APPEND ICUIO_SOURCE_FILES ${ICUIO_HEADER_FILES})

ADD_DEFINITIONS(
    -DU_IO_IMPLEMENTATION
)

ADD_LIBRARY(icuio SHARED ${ICUIO_SOURCE_FILES} )
TARGET_LINK_LIBRARIES(icuio icuin icuuc)

INSTALL(TARGETS icuio
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
INSTALL(DIRECTORY ${PROJECT_SOURCE_DIR}/unicode
        DESTINATION "${INSTALL_INC_DIR}" FILES_MATCHING PATTERN "*.h")
