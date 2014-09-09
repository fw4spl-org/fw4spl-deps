cmake_minimum_required(VERSION 2.8)

project(cryptoppBuilder)

include(ExternalProject)

getCachedUrl(http://www.cryptopp.com/cryptopp562.zip CACHED_URL)

set(CRYPTOPP_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(CRYPTOPP_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
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
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(cryptopp CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindCryptoPP.cmake ${CMAKE_INSTALL_PREFIX}/FindCryptoPP.cmake
    COMMENT "Install Configuration file"
)


