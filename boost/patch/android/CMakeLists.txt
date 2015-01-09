cmake_minimum_required(VERSION 2.8)
project(android-boost)

#find patched boost directory
set(boost_root ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Boost repo")

if(NOT EXISTS ${boost_root})
message(FATAL_ERROR
  "${boost_root} does not exist!
    Please run ${CMAKE_CURRENT_SOURCE_DIR}/get_boost.sh to get a copy of boost source")
endif()

set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}" )
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS} -fexceptions -frtti")
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE})

if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
endif()

message(STATUS "CMAKE_BUILD_TYPE : ${CMAKE_BUILD_TYPE}")
message(STATUS "CMAKE_C_FLAGS : ${CMAKE_C_FLAGS}")
message(STATUS "CMAKE_CXX_FLAGS : ${CMAKE_CXX_FLAGS}")

set(Boost_INCLUDE_DIRS ${boost_root})
set(Boost_LIBRARIES)
set(Boost_LINK_DIRS ${LIBRARY_OUTPUT_PATH})

macro(add_boost_lib name)
    file(GLOB_RECURSE lib_srcs "${boost_root}/libs/${name}/src/*.cpp")
    foreach(arg ${ARGN})
        if("${arg}" MATCHES "^-")
            string(REGEX REPLACE "^-" "${boost_root}/libs/${name}/src/" arg "${arg}")
            list(REMOVE_ITEM lib_srcs ${arg})
        endif()
    endforeach()
    add_library( boost_${name} SHARED ${lib_srcs} )
    list(APPEND Boost_LIBRARIES boost_${name})
    install(TARGETS boost_${name} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
endmacro()

macro(add_boost_lib_subdir name src_subdir)
    file(GLOB lib_srcs1 ${boost_root}/libs/${name}/src/*.cpp)
    file(GLOB_RECURSE lib_srcs2 ${boost_root}/libs/${name}/src/${src_subdir}/*.cpp)
    
    set(lib_srcs ${lib_srcs1} ${lib_srcs2})
    
    foreach(arg ${ARGN})
        if("${arg}" MATCHES "^-")
            string(REGEX REPLACE "^-" "${boost_root}/libs/${name}/src/" arg "${arg}")
            list(REMOVE_ITEM lib_srcs ${arg})
        endif()
    endforeach()
    
    add_library( boost_${name} SHARED ${lib_srcs} )
    list(APPEND Boost_LIBRARIES boost_${name})
    install(TARGETS boost_${name} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
endmacro()

include_directories(${boost_root} ${CMAKE_CURRENT_SOURCE_DIR})
install(DIRECTORY ${boost_root}/boost DESTINATION ${CMAKE_INSTALL_PREFIX}/include)

add_boost_lib(system)
add_boost_lib(filesystem)
target_link_libraries(boost_filesystem boost_system)
add_boost_lib(program_options)
target_link_libraries(boost_program_options boost_system)
add_boost_lib(regex)
target_link_libraries(boost_regex boost_system)
add_boost_lib(signals)
target_link_libraries(boost_signals boost_system)
add_boost_lib_subdir(thread pthread -pthread/once_atomic.cpp)
target_link_libraries(boost_thread boost_system)
add_boost_lib(date_time)
target_link_libraries(boost_date_time boost_system)
add_boost_lib(chrono)
target_link_libraries(boost_chrono boost_system)
add_boost_lib(iostreams -bzip2.cpp)
target_link_libraries(boost_iostreams boost_system z)

add_definitions(
    -DBOOST_ALL_DYN_LINK
    -DBOOST_THREAD_DONT_PROVIDE_DEPRECATED_FEATURES_SINCE_V3_0_0
    -DBOOST_THREAD_PROVIDES_FUTURE
    -DBOOST_THREAD_VERSION=2
    -DNO_ZLIB=0
    -DNO_BZIP2=1
)

configure_file(${CMAKE_SOURCE_DIR}/BoostConfig.cmake.in
               ${CMAKE_BINARY_DIR}/BoostConfig.cmake @ONLY)
