cmake_minimum_required(VERSION 3.0)

project(android_native_app_builder)

include(ExternalProject)

ExternalProject_Add(
    android_native_app
    URL ${CMAKE_CURRENT_SOURCE_DIR}/cmake
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${COMMON_CMAKE_ARGS}
)
