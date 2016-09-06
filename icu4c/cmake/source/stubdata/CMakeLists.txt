cmake_minimum_required(VERSION 2.8)

project(icudt)

include_directories(
    ../common
)
  
set(ICUDT_SOURCE_FILES stubdata.c)

add_definitions(
    -DSTUBDATA_BUILD
)

add_library(icudt SHARED ${ICUDT_SOURCE_FILES} )

install(TARGETS icudt
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
