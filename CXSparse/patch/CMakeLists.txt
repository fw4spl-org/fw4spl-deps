CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(CXSparse C)

set(CXSPARSE_INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "Installation directory for executables")
set(CXSPARSE_INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "Installation directory for libraries")
set(CXSPARSE_INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" CACHE PATH "Installation directory for headers")


set(CXSPARSE_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/Include/cs.h
                     ${CMAKE_CURRENT_SOURCE_DIR}/Include/SuiteSparse_config.h)


include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Include)

FILE(GLOB CXSPARSE_SRCS "Source/*.c")

set_source_files_properties(${CXSPARSE_SRCS} PROPERTIES LANGUAGE C)
add_definitions("-DNCOMPLEX")

if(BUILD_SHARED_LIBS)
    add_library(CXSparse SHARED ${CXSPARSE_SRCS} ${CXSPARSE_HEADERS})
    add_definitions(-DDLL_EXPORTS)
else(BUILD_SHARED_LIBS)
    add_library(CXSparse STATIC ${CXSPARSE_SRCS} ${CXSPARSE_HEADERS})
endif(BUILD_SHARED_LIBS)

install(TARGETS CXSparse
        RUNTIME DESTINATION "${CXSPARSE_INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${CXSPARSE_INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${CXSPARSE_INSTALL_LIB_DIR}" )

install(FILES ${CXSPARSE_HEADERS} DESTINATION "${CXSPARSE_INSTALL_INC_DIR}/CXSparse")

#add_subdirectory(Demo)
