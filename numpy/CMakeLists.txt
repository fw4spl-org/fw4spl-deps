cmake_minimum_required(VERSION 3.0)

project(numpyBuilder)

include(ExternalProject)


set(CACHED_URL http://sourceforge.net/projects/numpy/files/NumPy/1.9.1/numpy-1.9.1.tar.gz)

set(PYTHON_DIR ${CMAKE_INSTALL_PREFIX})
set(PYTHON_INCLUDE ${PYTHON_DIR}/include/python2.7)
set(PYTHON_INTERPRETER ${PYTHON_DIR}/bin/python)

file(TO_CMAKE_PATH ${CMAKE_INSTALL_PREFIX} NUMPY_INSTALL_PATH)
set(ENV_WRAPPER)
if(WIN32)
    configure_file(envwrapper/env.bat.in
        ${CMAKE_CURRENT_BINARY_DIR}/env.bat @ONLY
        )
    set(ENV_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/env.bat)
    string(REGEX REPLACE "/" "\\\\" NUMPY_INSTALL_PATH ${NUMPY_INSTALL_PATH})
else(WIN32)
    configure_file(envwrapper/env.sh.in
        ${CMAKE_CURRENT_BINARY_DIR}/env.sh @ONLY
        )
    execute_process(COMMAND chmod u+x ${CMAKE_CURRENT_BINARY_DIR}/env.sh)

    set(ENV_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/env.sh)
endif()

set(SETUP ${PYTHON_INTERPRETER}
          setup.py
          build_ext
          --library-dirs=${PYTHON_DIR}/lib
)

if(IS_DEBUG)
    list(APPEND SETUP --debug
                      build --debug
    )
endif()

list(APPEND SETUP install
                  --prefix ${NUMPY_INSTALL_PATH}
)

ExternalProject_Add(
    numpy
    URL ${CACHED_URL}
    URL_HASH SHA256=0075bbe07e30b659ae4415446f45812dc1b96121a493a4a1f8b1ba77b75b1e1c
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS python
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${ENV_WRAPPER} ${SETUP}
    INSTALL_COMMAND ""
    INSTALL_DIR ${NUMPY_INSTALL_PATH}
)
