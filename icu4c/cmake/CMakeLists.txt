cmake_minimum_required(VERSION 2.8)

project(icu)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" 
    CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" 
    CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include/icu" 
    CACHE PATH "Installation directory for headers")

set(ICU_MAJOR_VERSION 51)
    
set(CMAKE_DEBUG_POSTFIX "${ICU_MAJOR_VERSION}d")
set(CMAKE_RELEASE_POSTFIX ${ICU_MAJOR_VERSION})
set(CMAKE_RELWITHDEBINFO_POSTFIX ${ICU_MAJOR_VERSION})
set(CMAKE_MINSIZEREL_POSTFIX ${ICU_MAJOR_VERSION})
 
add_subdirectory(source/stubdata)
add_subdirectory(source/common)
add_subdirectory(source/i18n)
add_subdirectory(source/io)
add_subdirectory(source/layout)
add_subdirectory(source/layoutex)
