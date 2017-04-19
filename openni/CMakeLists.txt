cmake_minimum_required(VERSION 3.0)

project(openniBuilder)

include(ExternalProject)


if(WIN32)

    # make sure Kinect SDK is installed before adding its related build step
    if(DEFINED ENV{KINECTSDK10_DIR})
        set (KINECT_BUILD_STEP devenv OpenNI.sln /project Kinect /build ${CMAKE_BUILD_TYPE})
    else()
        message(WARNING "Kinect SDK is not found, the kinect driver will not be compiled.")
        set (KINECT_BUILD_STEP "")
    endif()

    # get archive on commit 958951f: fix(orbbec): removed warning as error.
    set(CACHED_URL https://github.com/fw4spl-org/OpenNI2/archive/958951f7a6c03c36915e9caf5084b15ecb301d2e.tar.gz)
    ExternalProject_Add(
            openni
            URL ${CACHED_URL}
            URL_HASH SHA256=a86911d2ff9c76598d620d5b193ec0fad56037a11a7d7f0f4a493ccff6ba638c
            DOWNLOAD_DIR ${ARCHIVE_DIR}
            BUILD_IN_SOURCE 1
            CONFIGURE_COMMAND ""
            BUILD_COMMAND devenv OpenNI.sln /project OpenNI /build ${CMAKE_BUILD_TYPE}
                  COMMAND devenv OpenNI.sln /project PS1080 /build ${CMAKE_BUILD_TYPE}
                  COMMAND devenv OpenNI.sln /project ORBBEC /build ${CMAKE_BUILD_TYPE}
                  COMMAND ${KINECT_BUILD_STEP}
            INSTALL_COMMAND ""
    )
    ExternalProject_Add_Step(
            openni INSTALL_OPENNI
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Bin/x64-${CMAKE_BUILD_TYPE}/OpenNI2/ ${CMAKE_INSTALL_PREFIX}/lib/openni2/OpenNI2
            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Bin/x64-${CMAKE_BUILD_TYPE}/OpenNI2.lib ${CMAKE_INSTALL_PREFIX}/lib/openni2/OpenNI2.lib
            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Bin/x64-${CMAKE_BUILD_TYPE}/OpenNI2.dll ${CMAKE_INSTALL_PREFIX}/bin/OpenNI2.dll
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Bin/x64-${CMAKE_BUILD_TYPE}/OpenNI2 ${CMAKE_INSTALL_PREFIX}/bin/OpenNI2
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
            DEPENDS libusb
            URL ${CACHED_URL}
            URL_HASH SHA256=a86911d2ff9c76598d620d5b193ec0fad56037a11a7d7f0f4a493ccff6ba638c
            DOWNLOAD_DIR ${ARCHIVE_DIR}
            DOWNLOAD_NAME openni_2.2.0.xx.tar.gz
            BUILD_IN_SOURCE 1
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${SET_COMPILER_ENV} ${MAKE} CFG=${CMAKE_BUILD_TYPE} INSTALL_LIB_DIR=${CMAKE_INSTALL_PREFIX}/lib INSTALL_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include -f <SOURCE_DIR>/Makefile
            INSTALL_COMMAND ""
    )

    ExternalProject_Add_Step(openni INSTALL_OPENNI
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Config/ ${CMAKE_INSTALL_PREFIX}/lib/openni2/
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/Bin/x64-${CMAKE_BUILD_TYPE}/OpenNI2/ ${CMAKE_INSTALL_PREFIX}/lib/openni2/OpenNI2
            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/Bin/x64-${CMAKE_BUILD_TYPE}/libOpenNI2${EXT} ${CMAKE_INSTALL_PREFIX}/lib/openni2/libOpenNI2${EXT}
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

ExternalProject_Add_Step(openni CopyFindFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindOpenNI2.cmake
                                    ${CMAKE_INSTALL_PREFIX}/FindOpenNI2.cmake
    COMMENT "Install FindOpenNI2 file"
    DEPENDEES install
)
