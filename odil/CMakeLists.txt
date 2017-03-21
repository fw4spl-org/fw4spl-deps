cmake_minimum_required(VERSION 3.0)

project(odilBuilder)

include(ExternalProject)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(CACHED_URL https://github.com/fw4spl-org/odil/archive/master.zip)

if(WIN32)
    # Grab compile definitions from fw-boost.cmake
    get_directory_property(ODIL_DEFINITIONS COMPILE_DEFINITIONS)
    foreach(DEF ${ODIL_DEFINITIONS})
        set(ODIL_CMAKE_CXX_FLAGS "/D${DEF} ${ODIL_CMAKE_CXX_FLAGS}")
    endforeach()
    
    # Add exception flag for noexcept keyword
    set(ODIL_CMAKE_CXX_FLAGS "${ODIL_CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS}")
    
    set(ODIL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_WRAPPERS=OFF
                        -DBUILD_EXAMPLES=OFF
                        -DBUILD_TESTING=OFF
                        -DCMAKE_CXX_FLAGS:STRING=${ODIL_CMAKE_CXX_FLAGS}
                        -DPC_ICU_INCLUDE_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/include/icu
                        -DLog4Cpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DJsonCpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DPC_JsonCpp_LIBRARY_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DPC_ICU_LIBRARY_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/lib
    )
else()
    set(ODIL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_WRAPPERS=OFF
                        -DBUILD_EXAMPLES=OFF
                        -DBUILD_TESTING=OFF
                        -DBoost_USE_DEBUG_PYTHON=ON
                        -DBoost_USE_MULTITHREADED=ON
                        -DBoost_COMPILER:STRING=${Boost_COMPILER}
                        -DCMAKE_CXX_FLAGS:STRING=-std=c++11
    )
endif()


ExternalProject_Add(
    odil
    URL ${CACHED_URL}
    URL_HASH SHA256=c02bb40b862fd7ddfa5234e30d5436154639b2d97b23db6eb72ea0f81d95fb0a
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME odil-with-windows-support.zip
    DEPENDS boost dcmtk jsoncpp icu4c log4cpp 
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ODIL_CMAKE_ARGS}
)

ExternalProject_Add_Step(odil CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindODIL.cmake ${CMAKE_INSTALL_PREFIX}/FindODIL.cmake
    COMMENT "Install CMake find package"
    DEPENDEES install
)