cmake_minimum_required(VERSION 3.0)

project(expatBuilder)

include(ExternalProject)


set(CACHED_URL http://downloads.sourceforge.net/expat/expat-2.1.0.tar.gz)

set(EXPAT_CMAKE_ARGS
    ${COMMON_CMAKE_ARGS}
    -DBUILD_tools=FALSE
    -DBUILD_examples=FALSE
    -DBUILD_tests=FALSE
    -DBUILD_shared=TRUE
)
set(EXPAT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

if(ANDROID OR WIN32)

    ExternalProject_Add(
        expat
        URL ${CACHED_URL}
        URL_MD5 dd7dab7a5fea97d2a6a43f511449b7cd
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        # Fix missing export
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${EXPAT_PATCH_DIR}/" "<SOURCE_DIR>/lib"
        CMAKE_ARGS ${EXPAT_CMAKE_ARGS}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    )
else()
    ExternalProject_Add(
        expat
        URL ${CACHED_URL}
        URL_MD5 dd7dab7a5fea97d2a6a43f511449b7cd
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${SET_COMPILER_ENV} <SOURCE_DIR>/configure
                          --enable-shared
                          --disable-static
                          --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_expat} install
    )

endif()

if(NOT WIN32)
    ExternalProject_Add_Step(expat COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_expat} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )
endif()
