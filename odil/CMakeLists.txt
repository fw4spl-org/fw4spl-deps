cmake_minimum_required(VERSION 3.0)

project(odilBuilder)

include(ExternalProject)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(VERSION 5d8a9f47fc1edd8ea3dc1a5c02c2b42b1e3d19bf)

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
                        -DBUILD_PYTHON_WRAPPERS=OFF
                        -DBUILD_JAVASCRIPT_WRAPPERS=OFF
                        -DBUILD_EXAMPLES=OFF
                        -DBUILD_TESTING=OFF
                        -DBUILD_SHARED_LIBS=ON
                        -DPC_ICU_INCLUDE_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/include/icu
                        -DLog4Cpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DJsonCpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DPC_JsonCpp_LIBRARY_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DPC_ICU_LIBRARY_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DCMAKE_CXX_FLAGS:STRING=${ODIL_CMAKE_CXX_FLAGS}
    )
    set(ODIL_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    # In Windows 10 Creators Update, ICU was integrated into Windows
    # FindICU is patched to use our version of ICU first (temporarily, because everyone doesn't use Windows10 Creators Update)
    set(ODIL_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${ODIL_PATCH_DIR}/FindICU.cmake.patch -d <SOURCE_DIR>)
else()
    set(ODIL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_PYTHON_WRAPPERS=OFF
                        -DBUILD_JAVASCRIPT_WRAPPERS=OFF
                        -DBUILD_EXAMPLES=OFF
                        -DBUILD_TESTING=OFF
                        -DBUILD_SHARED_LIBS=ON
                        -DBoost_USE_DEBUG_PYTHON=ON
                        -DBoost_USE_MULTITHREADED=ON
                        -DBoost_COMPILER:STRING=${Boost_COMPILER}
    )
    set(ODIL_PATCH_CMD)
endif()


set(ODIL_DEPENDS boost dcmtk jsoncpp log4cpp)
if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    list(APPEND ODIL_DEPENDS icu4c)
endif()

ExternalProject_Add(
    odil
    URL ${CACHED_URL}
    URL_HASH SHA256=046b15ac38227f33e124d3154a6920a11733d2f341d37bec71fe21292b600432
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME odil-${VERSION}.zip
    PATCH_COMMAND ${ODIL_PATCH_CMD}
    DEPENDS ${ODIL_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ODIL_CMAKE_ARGS}
)

fwInstallFile(
    BINPKG odil
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindODIL.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindODIL.cmake
)
