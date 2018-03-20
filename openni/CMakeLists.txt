cmake_minimum_required(VERSION 3.0)

project(openniBuilder)

include(ExternalProject)

set (SHA256 ac50b56c7deda0e893c443c7e2614855a9f78bc3458af88e77b9727c97995cae)
if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    set(OPENNI_DEBUG "Debug")
else()
    set(OPENNI_DEBUG "Release")
endif()

if(WIN32)

    # make sure Kinect SDK is installed before adding its related build step
    if(DEFINED ENV{KINECTSDK10_DIR})
        set (KINECT_BUILD_STEP devenv OpenNI.sln /project Kinect /build ${OPENNI_DEBUG})
    else()
        message(WARNING "Kinect SDK is not found, the kinect driver will not be compiled.")
        set (KINECT_BUILD_STEP "")
    endif()

    # get archive on commit 958951f: fix(orbbec): removed warning as error.
    set(CACHED_URL https://github.com/fw4spl-org/OpenNI2/archive/958951f7a6c03c36915e9caf5084b15ecb301d2e.tar.gz)
    ExternalProject_Add(
            openni
            URL ${CACHED_URL}
            URL_HASH SHA256=${SHA256}
            DOWNLOAD_DIR ${ARCHIVE_DIR}
            BUILD_IN_SOURCE 1
            CONFIGURE_COMMAND ""
            BUILD_COMMAND devenv OpenNI.sln /project OpenNI /build ${OPENNI_DEBUG}
                  COMMAND devenv OpenNI.sln /project PS1080 /build ${OPENNI_DEBUG}
                  COMMAND devenv OpenNI.sln /project ORBBEC /build ${OPENNI_DEBUG}
                  COMMAND ${KINECT_BUILD_STEP}
            INSTALL_COMMAND ""
    )
    ExternalProject_Add_Step(
            openni INSTALL_OPENNI
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Bin/x64-${OPENNI_DEBUG}/OpenNI2/ ${CMAKE_INSTALL_PREFIX}/lib/OpenNI2
            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Bin/x64-${OPENNI_DEBUG}/OpenNI2.lib ${CMAKE_INSTALL_PREFIX}/lib/OpenNI2.lib
            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Bin/x64-${OPENNI_DEBUG}/OpenNI2.dll ${CMAKE_INSTALL_PREFIX}/bin/OpenNI2.dll
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Bin/x64-${OPENNI_DEBUG}/OpenNI2 ${CMAKE_INSTALL_PREFIX}/bin/OpenNI2
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Config ${CMAKE_INSTALL_PREFIX}/bin
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Include ${CMAKE_INSTALL_PREFIX}/include/openni2
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDEES install
    )
else()
    set(CACHED_URL https://github.com/fw4spl-org/OpenNI2/archive/958951f7a6c03c36915e9caf5084b15ecb301d2e.tar.gz)
    # Building Prerequisites:
    # - LibUSB 1.0.x
    #     sudo apt-get install libusb-1.0-0-dev
    # - LibUDEV
    #     sudo apt-get install libudev-dev

    if (APPLE)
        set (EXT ".dylib")
    else()
        set (EXT ".so")
    endif()

    ExternalProject_Add(
            openni
            URL ${CACHED_URL}
            URL_HASH SHA256=${SHA256}
            DOWNLOAD_DIR ${ARCHIVE_DIR}
            DOWNLOAD_NAME openni_2.2.0.xx.tar.gz
            BUILD_IN_SOURCE 1
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${SET_COMPILER_ENV} ${MAKE} CFG=${OPENNI_DEBUG} ALLOW_WARNINGS=1 GLUT_SUPPORTED=0 INSTALL_LIB_DIR=${CMAKE_INSTALL_PREFIX}/lib INSTALL_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include -f <SOURCE_DIR>/Makefile main
            INSTALL_COMMAND ""
    )

    ExternalProject_Add_Step(openni INSTALL_OPENNI
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Config/OpenNI2/ ${CMAKE_INSTALL_PREFIX}/lib/OpenNI2/
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Bin/x64-${OPENNI_DEBUG}/OpenNI2 ${CMAKE_INSTALL_PREFIX}/lib/OpenNI2
            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Bin/x64-${OPENNI_DEBUG}/libOpenNI2${EXT} ${CMAKE_INSTALL_PREFIX}/lib/libOpenNI2${EXT}
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Include ${CMAKE_INSTALL_PREFIX}/include/openni2
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDEES install
    )

    if(NOT APPLE)
        ExternalProject_Add_Step(openni INSTALL_RULES
                COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Packaging/Linux/primesense-usb.rules ${CMAKE_INSTALL_PREFIX}/primesense-usb.rules
                COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Packaging/Linux/orbbec-usb.rules ${CMAKE_INSTALL_PREFIX}/orbbec-usb.rules
                COMMAND ${CMAKE_COMMAND} -E echo "LINUX WARNING : The file '${CMAKE_INSTALL_PREFIX}/primesense-usb.rules' should be copied \
                                                  to '/etc/udev/rules.d/557-primesense-usb.rules' with admin rights (sudo)"
                COMMAND ${CMAKE_COMMAND} -E echo "LINUX WARNING : The file '${CMAKE_INSTALL_PREFIX}/orbbec-usb.rules' should be copied \
                                                  to '/etc/udev/rules.d/558-orbbec-usb.rules' with admin rights (sudo)"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                DEPENDEES INSTALL_OPENNI
        )
    endif()

endif()

fwInstallFile(
    BINPKG openni
    SRC ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindOpenNI2.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindOpenNI2.cmake
)
