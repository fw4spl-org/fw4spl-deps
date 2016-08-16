cmake_minimum_required(VERSION 3.0)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" CACHE PATH "Installation directory for headers")

set(GLEW_EXT_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/include/GL/glew.h
                     ${CMAKE_CURRENT_SOURCE_DIR}/include/GL/glxew.h
                     ${CMAKE_CURRENT_SOURCE_DIR}/include/GL/wglew.h)

set(GLEW_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/glew)

find_package(OpenGL REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${OPENGL_INCLUDE_DIR})

option(GLEW_MX "Build Glew with Multiple Rendering Contexts." ON)
if(GLEW_MX)
    add_definitions(-DGLEW_MX)
endif()

if(WIN32)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    list(APPEND GLEW_SRC ${CMAKE_CURRENT_SOURCE_DIR}/build/glew.rc)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(GLEW_LIB_NAME "glew32")
else(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(GLEW_LIB_NAME "GLEW")
    set(DLL_PREFIX "lib")
endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")

if(BUILD_SHARED_LIBS)
    add_library(glew SHARED ${GLEW_SRC} ${GLEW_EXT_HEADERS})
    add_definitions(-DGLEW_BUILD)
    target_link_libraries(glew ${OPENGL_LIBRARIES})
    set_target_properties(glew PROPERTIES OUTPUT_NAME ${GLEW_LIB_NAME} PREFIX "${DLL_PREFIX}")
else()
    add_library(glew STATIC ${GLEW_SRC} ${GLEW_EXT_HEADERS})
    add_definitions(-DGLEW_STATIC)
    set_target_properties(glew PROPERTIES OUTPUT_NAME "glew_static")
    set_target_properties(glew PROPERTIES OUTPUT_NAME ${GLEW_LIB_NAME} PREFIX lib)
endif()

install(TARGETS glew
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )

install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/GL" 
        DESTINATION "${INSTALL_INC_DIR}")
