cmake_minimum_required(VERSION 2.6)

project(tetgen)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include")

set(TETGEN_SRCS predicates.cxx tetgen.cxx)
set(TETGEN_INC tetgen.h)

if(MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif(MSVC)

add_executable(tetgen ${TETGEN_SRCS})

add_library(tetlib STATIC ${TETGEN_SRCS})
SET_TARGET_PROPERTIES(tetlib PROPERTIES COMPILE_FLAGS "-DTETLIBRARY")

install(TARGETS tetgen tetlib
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
install(FILES ${TETGEN_INC} DESTINATION "${INSTALL_INC_DIR}")
