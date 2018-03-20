cmake_minimum_required(VERSION 3.0)

project(cppunitBuilder)

include(ExternalProject)

set(CACHED_URL http://dev-www.libreoffice.org/src/cppunit-1.14.0.tar.gz)
set(CPPUNIT_HASHSUM 3d569869d27b48860210c758c4f313082103a5e58219a7669b52bfd29d674780)

if(WIN32)
    set(CPPUNIT_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    set(CPPUNIT_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                           -DBUILD_SHARED_LIBS:BOOL=ON
    )
    ExternalProject_Add(
        cppunit
        URL ${CACHED_URL}
        URL_HASH SHA256=${CPPUNIT_HASHSUM}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${CPPUNIT_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${CPPUNIT_CMAKE_ARGS}
    )
else()
    set(FIX_CONFIGURE)
    if(APPLE)
        # cppunit's configure return an error on osx, but configure worked well
        set(FIX_CONFIGURE || echo fix...)
    endif()
    ExternalProject_Add(
        cppunit
        URL ${CACHED_URL}
        URL_HASH SHA256=${CPPUNIT_HASHSUM}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${SET_COMPILER_ENV} <SOURCE_DIR>/configure
                        --enable-shared
                        --disable-static
                        --disable-doxygen
                        --prefix=${CMAKE_INSTALL_PREFIX}
                        ${FIX_CONFIGURE}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_cppunit} install
    )

    ExternalProject_Add_Step(cppunit COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_cppunit} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )
endif()

fwInstallFile(
    BINPKG cppunit
    SRC ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/FindCppUnit.cmake
    DEST ${CMAKE_INSTALL_PREFIX}/FindCppUnit.cmake
)
