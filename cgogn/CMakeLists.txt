CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(cgognBuilder)

INCLUDE(ExternalProject)

SET(CGOGN_CMAKE_ARGS 
                        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                        -DBoost_DEBUG=OFF
                        -DBoost_NO_SYSTEM_PATHS=ON
                        -DBoost_USE_DEBUG_PYTHON=ON
                        -DBoost_USE_MULTITHREADED=ON
                        -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}
)



ExternalProject_Add(
    cgogn
    URL http://www.visiblepatient.com/dev/cgogn/cgogn_185731fbdd50.zip
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS libxml zlib boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CGOGN_CMAKE_ARGS}
 
)


