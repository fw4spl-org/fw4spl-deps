list(APPEND BOOST_ARGS
    --prefix=${INSTALL_PREFIX_boost}/${CMAKE_INSTALL_PREFIX}
    cxxflags=-ftemplate-depth=256
    cxxflags=-std=c++11
)

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(BOOST_USER_CONFIG "using clang : : ${CMAKE_CXX_COMPILER} ;")
    list(APPEND BOOST_ARGS toolset=clang)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(BOOST_USER_CONFIG "using gcc : : ${CMAKE_CXX_COMPILER} ;")
endif()

set(BOOTSTRAP_CMD bash
                  bootstrap.sh
                  --with-icu=${CMAKE_INSTALL_PREFIX}
)

configure_file(${BOOST_PATCH_DIR}/user-config.jam.cmake
               ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam @ONLY
)

set(PATCH_CMD ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_BINARY_DIR}/user-config.jam" "<SOURCE_DIR>/user-config.jam" )

set(SETENV export PATH=${CMAKE_INSTALL_PREFIX}/bin:${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/include:$ENV{PATH} &&)

ExternalProject_Add(
    boost
    URL ${CACHED_URL}
    URL_HASH SHA256=${BOOST_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${PATCH_CMD}
    CONFIGURE_COMMAND ${SETENV} ${BOOTSTRAP_CMD}
    BUILD_COMMAND ${SETENV} <SOURCE_DIR>/b2 -j${NUMBER_OF_PARALLEL_BUILD} ${BOOST_ARGS} -sHOME=<SOURCE_DIR> install
    INSTALL_COMMAND ""
)

ExternalProject_Add_Step(boost COPY_FILES
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_boost} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
)
