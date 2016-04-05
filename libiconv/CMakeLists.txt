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
        STEP_TARGETS CopyConfigFileToInstall
    )
    
elseif(WIN32)
    set(CACHED_URL https://win-iconv.googlecode.com/files/win-iconv-0.0.6.tar.bz2)

    ExternalProject_Add(
        libiconv
        URL ${CACHED_URL}
        URL_HASH SHA256=b54da6cb14f6930fa8bbf3bee4225e842fd6dc0b2377081f1a809ec1ab761aac
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${LIBICONV_CMAKE_ARGS}
        STEP_TARGETS CopyConfigFileToInstall
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
        STEP_TARGETS CopyConfigFileToInstall
    )
    
endif()

if(NOT WIN32)
    ExternalProject_Add_Step(libiconv COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_libiconv} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
endif()
ExternalProject_Add_Step(libiconv CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindIconv.cmake ${CMAKE_INSTALL_PREFIX}/FindIconv.cmake
    COMMENT "Install configuration file"
)
