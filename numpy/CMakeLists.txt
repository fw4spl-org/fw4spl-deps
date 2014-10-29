cmake_minimum_required(VERSION 2.8)

project(numpyBuilder)

include(ExternalProject)


getCachedUrl(http://downloads.sourceforge.net/project/numpy/NumPy/1.6.2/numpy-1.6.2.tar.gz CACHED_URL)

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


set(NUMPY_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
if(WIN32)

    set(NUMPY_PATCH_CMD ${CMAKE_COMMAND} -E copy_directory "${NUMPY_PATCH_DIR}/" "<SOURCE_DIR>/")

else(WIN32)

    set(NUMPY_PATCH_CMD "")

endif(WIN32)

ExternalProject_Add(
    numpy
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS python
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${NUMPY_PATCH_CMD}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${ENV_WRAPPER} ${SETUP}
    INSTALL_COMMAND ""
    INSTALL_DIR ${NUMPY_INSTALL_PATH}
)
