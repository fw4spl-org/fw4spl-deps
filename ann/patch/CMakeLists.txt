cmake_minimum_required(VERSION 2.8)

project(ANN)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" CACHE PATH "Installation directory for headers")

set(ANN_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src )
set(ANN_INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include/ )

set(ANN_SRC ${ANN_SRC_DIR}/ANN.cpp                    
            ${ANN_SRC_DIR}/bd_fix_rad_search.cpp      
            ${ANN_SRC_DIR}/bd_pr_search.cpp         
            ${ANN_SRC_DIR}/bd_search.cpp            
            ${ANN_SRC_DIR}/bd_tree.cpp          
            ${ANN_SRC_DIR}/brute.cpp            
            ${ANN_SRC_DIR}/kd_dump.cpp          
            ${ANN_SRC_DIR}/kd_fix_rad_search.cpp
            ${ANN_SRC_DIR}/kd_pr_search.cpp
            ${ANN_SRC_DIR}/kd_search.cpp   
            ${ANN_SRC_DIR}/kd_split.cpp
            ${ANN_SRC_DIR}/kd_tree.cpp
            ${ANN_SRC_DIR}/kd_util.cpp
            ${ANN_SRC_DIR}/perf.cpp )
    

set(ANN_HEADERS ${ANN_INC_DIR}/ANN/ANN.h
                ${ANN_INC_DIR}/ANN/ANNperf.h
                ${ANN_INC_DIR}/ANN/ANNx.h)

include_directories(${ANN_INC_DIR})

if(BUILD_SHARED_LIBS)
    add_library(ANN SHARED ${ANN_SRC} ${ANN_HEADERS})
    add_definitions(-DDLL_EXPORTS)
else(BUILD_SHARED_LIBS)
    add_library(ANN STATIC ${ANN_SRC} ${ANN_HEADERS})
endif(BUILD_SHARED_LIBS)

if(CMAKE_COMPILER_IS_GNUCXX AND UNIX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC") 
endif(CMAKE_COMPILER_IS_GNUCXX AND UNIX)

install(TARGETS ANN
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
        
install(FILES ${ANN_HEADERS} DESTINATION "${INSTALL_INC_DIR}/ANN")
