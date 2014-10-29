cmake_minimum_required(VERSION 2.8)

project(libiconvBuilder)

include(ExternalProject)

if(WIN32)
    getCachedUrl(https://win-iconv.googlecode.com/files/win-iconv-0.0.6.tar.bz2 CACHED_URL)

    set(LIBICONV_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${LIBICONV_CMAKE_ARGS}
        STEP_TARGETS CopyConfigFileToInstall
    )
else()
    set(LIBICONV_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    getCachedUrl(http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz CACHED_URL)

    if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        set(LIBICONV_PATCH_CMD && patch -t -N -p1 < ${LIBICONV_PATCH_DIR}/linux-remove-gets.patch )
    endif()

    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                          --enable-shared
                          --disable-static
                          --without-libintl
                          --enable-extra-encodings
                          --prefix=${CMAKE_INSTALL_PREFIX}
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory "${LIBICONV_PATCH_DIR}/" "<SOURCE_DIR>/" ${LIBICONV_PATCH_CMD}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_libiconv} install
        STEP_TARGETS CopyConfigFileToInstall
    )

    ExternalProject_Add_Step(libiconv COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_libiconv} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
endif()

ExternalProject_Add_Step(libiconv CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindIconv.cmake ${CMAKE_INSTALL_PREFIX}/FindIconv.cmake
    COMMENT "Install configuration file"
)
