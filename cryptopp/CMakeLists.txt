cmake_minimum_required(VERSION 3.0)

project(cryptoppBuilder)

include(ExternalProject)

set(CACHED_URL http://www.cryptopp.com/cryptopp562.zip)

set(CRYPTOPP_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(CRYPTOPP_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DCRYPTOPP_BUILD_SHARED_LIBS=ON
                        -DCRYPTOPP_BUILD_STATIC_LIBS=ON
                        -DCRYPTOPP_BUILD_TESTS=OFF
)

ExternalProject_Add(
    cryptopp
    URL ${CACHED_URL}
    URL_HASH SHA1=ddc18ae41c2c940317cd6efe81871686846fa293
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


