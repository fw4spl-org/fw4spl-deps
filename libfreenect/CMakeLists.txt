cmake_minimum_required(VERSION 3.0)

project(libfreenect)

include(ExternalProject)

set(CACHED_URL https://github.com/OpenKinect/libfreenect/archive/v0.5.7.tar.gz)

set(LIBFREENECT_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DBUILD_OPENNI2_DRIVER=ON
                           -DBUILD_EXAMPLES=OFF
)

ExternalProject_Add(
    libfreenect
    URL ${CACHED_URL}
    URL_HASH SHA256=5f22c9a0260efd5a31d8e6465bb06b2b389f61b8f7714e0b42b7b20314e5ef59
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS openni
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${LIBFREENECT_CMAKE_ARGS}
)

ExternalProject_Add_Step(libfreenect INSTALL_LIBFREENECT
        COMMAND ${CMAKE_COMMAND} -E copy_directory lib/OpenNI2-FreenectDriver lib/OpenNI2/Drivers
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
        DEPENDEES install
)

if(UNIX AND NOT APPLE)
    ExternalProject_Add_Step(libfreenect INSTALL_RULES
            COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/platform/linux/udev/51-kinect.rules ${CMAKE_INSTALL_PREFIX}/51-kinect.rules
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "LINUX WARNING : The file '${CMAKE_INSTALL_PREFIX}/51-kinect.rules' should be copy to '/etc/udev/rules.d/51-kinect.rules' with admin rights (sudo)"
            DEPENDEES INSTALL_LIBFREENECT
    )
endif()

