cmake_minimum_required(VERSION 3.0)

project(realsense)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/librealsense/archive/v0.9.1.1.tar.gz)

set(REALSENSE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                         -DBUILD_EXAMPLES=OFF
)

ExternalProject_Add(
    realsense
    URL ${CACHED_URL}
    URL_HASH SHA256=511721c264b75ce6f41e7191851f69866c0f81702d18e007ac64cc28f950cfbd
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME librealsense-0.9.1.1.tar.gz
    DEPENDS ${REALSENSE_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${REALSENSE_CMAKE_ARGS}
)

ExternalProject_Add_Step(realsense CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/Findlibrealsense.cmake ${CMAKE_INSTALL_PREFIX}/Findlibrealsense.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
add_custom_target(realsense_cmake_uninstall
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_INSTALL_PREFIX}/Findlibrealsense.cmake
    COMMENT "Uninstall realsense CMake find package"
)
add_dependencies(realsense_uninstall realsense_cmake_uninstall)
