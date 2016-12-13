cmake_minimum_required(VERSION 3.0)

project(pythonBuilder)

include(ExternalProject)

set(CACHED_URL http://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz)
set(PYTHON_HASHSUM 1524b840e42cf3b909e8f8df67c1724012c7dc7f9d076d4feef2d3eff031e8a0)

if(WIN32)

    set(PYTHON_BUILD_CMD PCbuild/build.bat)
    if(${IS_DEBUG})
        set(PYTHON_BUILD_CMD ${PYTHON_BUILD_CMD} -c Debug)
    else()
        set(PYTHON_BUILD_CMD ${PYTHON_BUILD_CMD} -c Release)
    endif()
    
    if(CMAKE_SIZEOF_VOID_P EQUAL 8) #x64
        set(PYTHON_BUILD_CMD ${PYTHON_BUILD_CMD} -p x64)
    else()
        set(PYTHON_BUILD_CMD ${PYTHON_BUILD_CMD} -p Win32)
    endif()

    ExternalProject_Add(
        python
        URL ${CACHED_URL}
        URL_HASH SHA256=${PYTHON_HASHSUM}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${PYTHON_BUILD_CMD}
        INSTALL_COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/manual_win_install.py <SOURCE_DIR> ${CMAKE_INSTALL_PREFIX}/Python-3.5.2 amd64
        STEP_TARGETS CopyConfigFileToInstall
    )
else()

    if(NOT APPLE)
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            set(SETENV export CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CFLAGS=-Wno-unused-value &&)  
        endif()
    endif()

    set(CONFIGURE_CMD <SOURCE_DIR>/configure
                      --enable-shared
                      --disable-static
                      --prefix=${CMAKE_INSTALL_PREFIX}
    )
    
    if(${IS_DEBUG})
        list(APPEND CONFIGURE_CMD --with-debug --with-pydebug)
    else()
        list(APPEND CONFIGURE_CMD --without-debug)
    endif()
    ExternalProject_Add(
        python
        URL ${CACHED_URL}
        URL_HASH SHA256=${PYTHON_HASHSUM}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${SETENV} ${CONFIGURE_CMD}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile -j${NUMBER_OF_PARALLEL_BUILD}
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_python} install
    )
    ExternalProject_Add_Step(python COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_python} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )
endif()


ExternalProject_Add_Step(python CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-python.cmake ${CMAKE_INSTALL_PREFIX}/fw-python.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
