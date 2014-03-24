CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(pythonBuilder)

INCLUDE(ExternalProject)

GET_CACHED_URL(http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tgz CACHED_URL)

IF(WIN32)
    SET(PYTHON_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    SET(PYTHON_CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DENABLE_CURSES:BOOL=OFF
        -DENABLE_CURSES_PANEL:BOOL=OFF
        -DENABLE_CRYPT:BOOL=OFF
        -DENABLE_MMAP:BOOL=OFF
        -DENABLE_IO:BOOL=OFF
        -DENABLE_MATH:BOOL=OFF
        -DENABLE_PARSER:BOOL=OFF
        -DENABLE_SHARED:BOOL=ON
        -DENABLE_STATIC:BOOL=OFF
    )
    ExternalProject_Add(
        python
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS zlib expat
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${PYTHON_PATCH_DIR}/" "<SOURCE_DIR>/"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${PYTHON_CMAKE_ARGS}
    )
ELSE(WIN32)
    SET(CONFIGURE_CMD <SOURCE_DIR>/configure
                      --enable-shared
                      --disable-static
                      --prefix=${CMAKE_INSTALL_PREFIX}
                      --without-curses #do not have nany effect
                      --without-panel  #do not have nany effect
                      --without-x11    #do not have nany effect
                      --without-tcl8.5 #do not have nany effect
    )
    IF(${IS_DEBUG})
        SET(CONFIGURE_CMD ${CONFIGURE_CMD} --with-debug --with-pydebug)
    ELSE(${IS_DEBUG})
        SET(CONFIGURE_CMD ${CONFIGURE_CMD} --without-debug)
    ENDIF(${IS_DEBUG})
    ExternalProject_Add(
        python
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${CONFIGURE_CMD}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile install
    )
ENDIF(WIN32)
