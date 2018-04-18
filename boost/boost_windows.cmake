#ZLIB_LIB_NAME is defined in zlib BinPkgs script
if(MSVC14)
    set(TOOLSET "msvc-14.0")
elseif(MSVC12)
    set(TOOLSET "msvc-12.0")
elseif(MSVC10)
    set(TOOLSET "msvc-10.0")
else()
    message(SEND_ERROR "Compiler version not supported")
endif()
list(APPEND BOOST_ARGS
    --prefix=${INSTALL_PREFIX_boost}
    --libdir=${INSTALL_PREFIX_boost}/lib
    --includedir=${INSTALL_PREFIX_boost}/include
    --abbreviate-paths
    --without-mpi
    --toolset=${TOOLSET}
    architecture=x86
    -sZLIB_BINARY=${ZLIB_LIB_NAME}
)

set(BOOST_USER_CONFIG)

set(BOOTSTRAP_CMD ./bootstrap.bat)

ExternalProject_Add(
    boost
    DEPENDS zlib libiconv
    URL ${CACHED_URL}
    URL_HASH SHA256=${BOOST_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${PATCH_CMD}
    CONFIGURE_COMMAND ${SETENV} ${BOOTSTRAP_CMD}
    BUILD_COMMAND ${SETENV} <SOURCE_DIR>/b2 -j${NUMBER_OF_PARALLEL_BUILD} ${BOOST_ARGS} -sHOME=<SOURCE_DIR> install
    INSTALL_COMMAND ""
)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/boost_move_dll.cmake
    "file(GLOB BOOST_DLLS RELATIVE ${INSTALL_PREFIX_boost}/lib ${INSTALL_PREFIX_boost}/lib/boost_*.dll)
     file(MAKE_DIRECTORY ${INSTALL_PREFIX_boost}/bin/)
     foreach(BOOST_DLL \${BOOST_DLLS})
         message(STATUS \"move : \${BOOST_DLL}\")
         file(RENAME ${INSTALL_PREFIX_boost}/lib/\${BOOST_DLL} ${INSTALL_PREFIX_boost}/bin/\${BOOST_DLL})
     endforeach()"
)

ExternalProject_Add_Step(boost MoveDll
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/boost_move_dll.cmake
    COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_boost} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
    DEPENDEES install
    COMMENT "Move dll files"
)
