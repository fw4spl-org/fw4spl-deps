cmake_minimum_required(VERSION 2.8)

project(icuio)

include_directories(
    ../common
    ../i18n
)

set(ICUIO_SOURCE_FILES
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

set(ICUIO_HEADER_FILES
    locbund.h
    ucln_io.h
    ufile.h
    ufmt_cmn.h
    uprintf.h
    uscanf.h
)

source_group("Source Files" FILES ${ICUIO_SOURCE_FILES})
source_group("Header Files" FILES ${ICUIO_HEADER_FILES})

set_source_files_properties(ICUIO_HEADER_FILES
                            PROPERTIES HEADER_FILE_ONLY TRUE)
list(APPEND ICUIO_SOURCE_FILES ${ICUIO_HEADER_FILES})

add_definitions(
    -DU_IO_IMPLEMENTATION
)

add_library(icuio SHARED ${ICUIO_SOURCE_FILES} )
target_link_libraries(icuio icuin icuuc)

install(TARGETS icuio
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
install(DIRECTORY ${PROJECT_SOURCE_DIR}/unicode
        DESTINATION "${INSTALL_INC_DIR}" FILES_MATCHING PATTERN "*.h")
