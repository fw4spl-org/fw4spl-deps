cmake_minimum_required(VERSION 3.0)

project(libusbBuilder)

include(ExternalProject)

# set(CACHED_URL https://github.com/libusb/libusb/archive/v1.0.19.tar.gz)
set(CACHED_URL http://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.19/libusb-1.0.19.tar.bz2)

if (APPLE)
    set(SETENV
        export "LDFLAGS=-framework IOKit -framework CoreFoundation -arch i386 -arch x86_64 "
        "CFLAGS=-arch i386 -arch x86_64 "
        &&
    )
    set(LIBUSB_CONFIGURE_CMD
        ./configure
        --prefix=${CMAKE_INSTALL_PREFIX}
        --disable-dependency-tracking
    )
else()
    set(SETENV "")
    set(LIBUSB_CONFIGURE_CMD
        ${SET_COMPILER_ENV} ./configure
        --prefix=${CMAKE_INSTALL_PREFIX}
    )
endif()

ExternalProject_Add(
    libusb
    URL ${CACHED_URL}
    URL_HASH SHA256=6c502c816002f90d4f76050a6429c3a7e0d84204222cbff2dce95dd773ba6840
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME libusb-1.0.19.tar.bz2
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${SETENV} ${LIBUSB_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install DESTDIR=${INSTALL_PREFIX_libusb}
)

ExternalProject_Add_Step(libusb COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_libusb} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)
