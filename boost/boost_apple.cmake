list(APPEND BOOST_ARGS
    --prefix=${INSTALL_PREFIX_boost}/${CMAKE_INSTALL_PREFIX}
    cxxflags=-std=c++11
    cxxflags=-stdlib=libc++
    cxxflags=-ftemplate-depth=256
    linkflags=-headerpad_max_install_names
)


set( BOOST_USER_CONFIG "using clang : : ${CMAKE_CXX_COMPILER} ;")
list(APPEND BOOST_ARGS toolset=clang)

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    list(APPEND BOOST_ARGS python-debugging=on)
    set(PYTHON_DEBUGGING "<python-debugging>on")
endif()

set(BOOTSTRAP_CMD bash
                  bootstrap.sh
                  --with-icu=${CMAKE_INSTALL_PREFIX}
                  --with-python-root=${CMAKE_INSTALL_PREFIX}
)

set(PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${BOOST_PATCH_DIR}/cpp11/adjacency_list.hpp.diff -d <SOURCE_DIR>)

set(SETENV export PATH=${CMAKE_INSTALL_PREFIX}/bin:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/include:$ENV{PATH} &&)

ExternalProject_Add(
    boost
    DEPENDS zlib python
    URL ${CACHED_URL}
    URL_HASH SHA256=${BOOST_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${PATCH_CMD}
    CONFIGURE_COMMAND ${SETENV} ${BOOTSTRAP_CMD}
    STEP_TARGETS CopyConfigFileToInstall
    BUILD_COMMAND ${SETENV} <SOURCE_DIR>/b2 -j${NUMBER_OF_PARALLEL_BUILD} ${BOOST_ARGS} -sHOME=<SOURCE_DIR> install
    INSTALL_COMMAND ""
)

ExternalProject_Add_Step(boost COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_boost} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)
