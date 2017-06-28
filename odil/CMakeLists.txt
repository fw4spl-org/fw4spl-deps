cmake_minimum_required(VERSION 3.0)

project(odilBuilder)

include(ExternalProject)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(VERSION binpkg_20170427)

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
                        -DCMAKE_CXX_FLAGS:STRING=${ODIL_CMAKE_CXX_FLAGS}
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


set(ODIL_DEPENDS boost dcmtk jsoncpp log4cpp)
if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    list(APPEND ODIL_DEPENDS icu4c)
endif()

ExternalProject_Add(
    odil
    URL ${CACHED_URL}
    URL_HASH SHA256=a133760bc0f69087b2c574fb09b69d15ae7558e9b60ade3fc259d86d35851956
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME odil-${VERSION}.zip
    DEPENDS ${ODIL_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ODIL_CMAKE_ARGS}
)

ExternalProject_Add_Step(odil CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindODIL.cmake ${CMAKE_INSTALL_PREFIX}/FindODIL.cmake
    COMMENT "Install CMake find package"
    DEPENDEES install
)
