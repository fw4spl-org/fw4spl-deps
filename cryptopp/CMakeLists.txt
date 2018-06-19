cmake_minimum_required(VERSION 3.0)

project(cryptoppBuilder)

include(ExternalProject)

set(CACHED_URL http://www.cryptopp.com/cryptopp700.zip)

set(CRYPTOPP_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(CRYPTOPP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DCRYPTOPP_BUILD_SHARED_LIBS=ON
                        -DCRYPTOPP_BUILD_STATIC_LIBS=ON
                        -DCRYPTOPP_BUILD_TESTS=OFF
)

ExternalProject_Add(
    cryptopp
    URL ${CACHED_URL}
    URL_HASH SHA1=1288682ae2f3062ea3a82ca2e90bd06d147568a4
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${CRYPTOPP_PATCH_DIR}/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CRYPTOPP_CMAKE_ARGS}
)

ExternalProject_Add_Step(cryptopp CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindCryptoPP.cmake ${CMAKE_INSTALL_PREFIX}/FindCryptoPP.cmake
    COMMENT "Install Configuration file"
    DEPENDEES install
)


