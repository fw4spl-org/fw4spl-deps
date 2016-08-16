cmake_minimum_required(VERSION 3.0)

project(openigtlinkBuilder)

include(ExternalProject)

set(OPENIGTLINK_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DBUILD_TESTING:BOOL=OFF
                           -DBUILD_EXEMPLE:BOOL=OFF
                           -DBUILD_DOCUMENTATION:BOOL=OFF
                           -DBUILD_SHARED_LIBS:BOOL=ON
                           -DOpenIGTLink_PROTOCOL_VERSION_2:BOOL=ON
   )

set(CACHED_URL https://github.com/openigtlink/OpenIGTLink/archive/5a501817c2da52e81db4db3eca6dd5111f94fed9.tar.gz)



#Android don't need to link with pThread lib so we need to remove it of target link library
#Furthermore lib OpenIGTLinkUtil needs to be linked with libm
if(ANDROID)
    set(PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/Source/CMakeLists.txt "<SOURCE_DIR>/Source/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/Source/igtlutil/CMakeLists.txt "<SOURCE_DIR>/Source/igtlutil/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/Source/igtlImageMessage.h "<SOURCE_DIR>/Source/igtlImageMessage.h"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/Source/igtlImageMessage.cxx "<SOURCE_DIR>/Source/igtlutil/igtlImageMessage.cxx" )
else()
    set(PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/Source/igtlImageMessage.h "<SOURCE_DIR>/Source/igtlImageMessage.h"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/Source/igtlImageMessage.cxx "<SOURCE_DIR>/Source/igtlutil/igtlImageMessage.cxx")
endif()

ExternalProject_Add(
    openigtlink
    URL ${CACHED_URL}
    URL_HASH SHA256=dae54b032e061dd3f3ddd37291fdfc7fdb15181c5544ad8d74a8b93f06bc697f
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME openigtlink.tar.gz
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    PATCH_COMMAND ${PATCH_CMD}
    CMAKE_ARGS ${OPENIGTLINK_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(openigtlink CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/fw-IGTL.cmake ${CMAKE_INSTALL_PREFIX}/fw-IGTL.cmake
    COMMENT "Install configuration file"
)
