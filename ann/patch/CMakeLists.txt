CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(ANN)

SET(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "Installation directory for executables")
SET(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "Installation directory for libraries")
SET(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" CACHE PATH "Installation directory for headers")

SET(ANN_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src )
SET(ANN_INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include/ )

SET(ANN_SRC ${ANN_SRC_DIR}/ANN.cpp                    
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
    

SET(ANN_HEADERS ${ANN_INC_DIR}/ANN/ANN.h
                ${ANN_INC_DIR}/ANN/ANNperf.h
                ${ANN_INC_DIR}/ANN/ANNx.h)

INCLUDE_DIRECTORIES(${ANN_INC_DIR})

IF(BUILD_SHARED_LIBS)
    ADD_LIBRARY(ANN SHARED ${ANN_SRC} ${ANN_HEADERS})
    ADD_DEFINITIONS(-DDLL_EXPORTS)
ELSE(BUILD_SHARED_LIBS)
    add_library(ANN STATIC ${ANN_SRC} ${ANN_HEADERS})
ENDIF(BUILD_SHARED_LIBS)

IF(CMAKE_COMPILER_IS_GNUCXX AND UNIX)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC") 
ENDIF(CMAKE_COMPILER_IS_GNUCXX AND UNIX)

INSTALL(TARGETS ANN
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
        
INSTALL(FILES ${ANN_HEADERS} DESTINATION "${INSTALL_INC_DIR}/ANN")
