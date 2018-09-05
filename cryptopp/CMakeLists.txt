cmake_minimum_required(VERSION 3.0)

project(cryptoppBuilder)

include(ExternalProject)

set(CRYPTOPP_TAG "CRYPTOPP_7_0_0")

set(CRYPTOPP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_SHARED=ON
                        -DBUILD_STATIC=ON
                        -DBUILD_TESTING=OFF
)

ExternalProject_Add(
    cryptopp
    GIT_REPOSITORY https://github.com/weidai11/cryptopp
    GIT_TAG ${CRYPTOPP_TAG}
    PATCH_COMMAND
    COMMAND ${CMAKE_COMMAND} -E remove_directory "<SOURCE_DIR>/cmake/"
    COMMAND git clone -b ${CRYPTOPP_TAG} https://github.com/noloader/cryptopp-cmake "<SOURCE_DIR>/cmake"
    COMMAND ${CMAKE_COMMAND} -E copy_directory "<SOURCE_DIR>/cmake/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CRYPTOPP_CMAKE_ARGS}
)

ExternalProject_Add_Step(cryptopp CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindCryptoPP.cmake ${CMAKE_INSTALL_PREFIX}/FindCryptoPP.cmake
    COMMENT "Install Configuration file"
    DEPENDEES install
)


