CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(numpyBuilder)

INCLUDE(ExternalProject)


GET_CACHED_URL(http://downloads.sourceforge.net/project/numpy/NumPy/1.6.2/numpy-1.6.2.tar.gz CACHED_URL)

IF(WIN32)

ENDIF(WIN32)

SET(PYTHON_DIR ${CMAKE_INSTALL_PREFIX})
SET(PYTHON_INCLUDE ${PYTHON_DIR}/include/python2.7)
SET(PYTHON_INTERPRETER ${PYTHON_DIR}/bin/python)

FILE(TO_CMAKE_PATH ${CMAKE_INSTALL_PREFIX} NUMPY_INSTALL_PATH)
SET(ENV_WRAPPER)
IF(WIN32)
    CONFIGURE_FILE(envwrapper/env.bat.in 
        ${CMAKE_CURRENT_BINARY_DIR}/env.bat @ONLY
        )
    SET(ENV_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/env.bat)
    STRING(REGEX REPLACE "/" "\\\\" NUMPY_INSTALL_PATH ${NUMPY_INSTALL_PATH})
ENDIF()

SET(SETUP ${PYTHON_INTERPRETER}
          setup.py
          build_ext
          --library-dirs=${PYTHON_DIR}/lib
)

IF(IS_DEBUG)
    LIST(APPEND SETUP --debug
                      build --debug
    )
ENDIF()


LIST(APPEND SETUP install
                  --prefix ${NUMPY_INSTALL_PATH}
)


SET(NUMPY_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
ExternalProject_Add(
    numpy
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS python
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${NUMPY_PATCH_DIR}/" "<SOURCE_DIR>/"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${ENV_WRAPPER} ${SETUP}
    INSTALL_COMMAND ""
    INSTALL_DIR ${NUMPY_INSTALL_PATH}
)