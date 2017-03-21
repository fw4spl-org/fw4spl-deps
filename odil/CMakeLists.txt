cmake_minimum_required(VERSION 3.0)

project(odilBuilder)

include(ExternalProject)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(VERSION 0.7.3.1)

set(CACHED_URL https://github.com/fw4spl-org/odil/archive/${VERSION}.zip)
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
    )
endif()


ExternalProject_Add(
    odil
    URL ${CACHED_URL}
    URL_HASH SHA256=53367a2f1440f92269beb62839b03a1dbc523b5d2ea98c3a53cf62da72141fee
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME odil${VERSION}.zip
    DEPENDS boost dcmtk jsoncpp icu4c log4cpp 
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ODIL_CMAKE_ARGS}
)

ExternalProject_Add_Step(odil CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindODIL.cmake ${CMAKE_INSTALL_PREFIX}/FindODIL.cmake
    COMMENT "Install CMake find package"
    DEPENDEES install
)