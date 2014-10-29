cmake_minimum_required(VERSION 2.8)

project(expatBuilder)

include(ExternalProject)


getCachedUrl(http://freefr.dl.sourceforge.net/expat/expat-2.1.0.tar.gz CACHED_URL)
if(WIN32)

    set(EXPAT_CMAKE_ARGS 
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBUILD_tools=FALSE
        -DBUILD_examples=FALSE
        -DBUILD_tests=FALSE
        -DBUILD_shared=TRUE
    )
    set(EXPAT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

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
else(WIN32)
    ExternalProject_Add(
        expat
        URL ${CACHED_URL}
        URL_MD5 dd7dab7a5fea97d2a6a43f511449b7cd
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                          --enable-shared
                          --disable-static
                          --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_expat} install
    )

    ExternalProject_Add_Step(expat COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_expat} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
endif(WIN32)
