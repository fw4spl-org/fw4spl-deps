cmake_minimum_required(VERSION 3.0)

project(libiconvBuilder)

include(ExternalProject)

set(LIBICONV_CMAKE_ARGS ${COMMON_CMAKE_ARGS})

if(ANDROID)
    
    set(CACHED_URL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz)
    
    set(LIBICONV_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    set(PATCH_CMD ${CMAKE_COMMAND} -E  copy_directory "${LIBICONV_PATCH_DIR}/" "<SOURCE_DIR>/")

    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${PATCH_CMD}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${LIBICONV_CMAKE_ARGS}
    )
    
elseif(WIN32)
    set(CACHED_URL https://github.com/win-iconv/win-iconv/archive/0.0.6.tar.gz)

    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        URL_HASH SHA256=d464bbe0410f72b09f301bead9f1cf091e6aa15e97323961ecb9242c0e7f609b
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${LIBICONV_CMAKE_ARGS}
    )
else()
    set(LIBICONV_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    set(CACHED_URL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz)

    if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        set(LIBICONV_PATCH_CMD && patch -t -N -p1 < ${LIBICONV_PATCH_DIR}/linux-remove-gets.patch )
    endif()

    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${SET_COMPILER_ENV} <SOURCE_DIR>/configure
                --enable-shared
                --disable-static
                --without-libintl
                --enable-extra-encodings
                --prefix=${CMAKE_INSTALL_PREFIX}
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory "${LIBICONV_PATCH_DIR}/" "<SOURCE_DIR>/" ${LIBICONV_PATCH_CMD}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_libiconv} install
    )
    
endif()

if(NOT WIN32)
    ExternalProject_Add_Step(libiconv COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_libiconv} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )
endif()

fwInstallFile(
    BINPKG libiconv
    SRC ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindIconv.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindIconv.cmake
)
