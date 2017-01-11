cmake_minimum_required(VERSION 3.0)

project(jpegBuilder)

include(ExternalProject)

set(CACHED_URL http://www.ijg.org/files/jpegsrc.v8d.tar.gz)

set(JPEG_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(JPEG_CMAKE_ARGS ${COMMON_CMAKE_ARGS})

ExternalProject_Add(
    jpeg
    URL ${CACHED_URL}
    URL_HASH SHA256=00029b1473f0f0ea72fbca3230e8cb25797fbb27e58ae2e46bb8bf5a806fe0b3
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${JPEG_PATCH_DIR}/" "<SOURCE_DIR>/"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${JPEG_CMAKE_ARGS}
)

if(WIN32)
    ExternalProject_Add_Step(jpeg RENAME_LIBJPEG
        COMMAND ${CMAKE_COMMAND} -E copy_if_different jpeg.lib libjpeg.lib
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib
        DEPENDEES install
    )
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fPIC")
endif()