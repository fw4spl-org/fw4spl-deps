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
    --prefix=${CMAKE_INSTALL_PREFIX}
    --libdir=${CMAKE_INSTALL_PREFIX}/lib
    --includedir=${CMAKE_INSTALL_PREFIX}/include
    --abbreviate-paths
    --without-mpi
    --toolset=${TOOLSET}
    architecture=x86
    -sZLIB_BINARY=${ZLIB_LIB_NAME}
)

set(BOOST_USER_CONFIG)

if(${IS_DEBUG})
    list(APPEND BOOST_ARGS python-debugging=on)
    set(PYTHON_DEBUGGING "<python-debugging>on")
endif()

configure_file(${BOOST_PATCH_DIR}/user-config.jam.cmake
               ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam @ONLY
)

set(PATCH_CMD ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_BINARY_DIR}/user-config.jam" "<SOURCE_DIR>/user-config.jam")
set(BOOTSTRAP_CMD ./bootstrap.bat)

ExternalProject_Add(
    boost
    DEPENDS zlib python libiconv
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

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/boost_move_dll.cmake
    "file(GLOB BOOST_DLLS RELATIVE ${CMAKE_INSTALL_PREFIX}/lib ${CMAKE_INSTALL_PREFIX}/lib/boost_*.dll)
     foreach(BOOST_DLL \${BOOST_DLLS})
         message(STATUS \"move : \${BOOST_DLL}\")
         file(RENAME ${CMAKE_INSTALL_PREFIX}/lib/\${BOOST_DLL} ${CMAKE_INSTALL_PREFIX}/bin/\${BOOST_DLL})
     endforeach()"
)

ExternalProject_Add_Step(boost MoveDll
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/boost_move_dll.cmake
    DEPENDEES install
    COMMENT "Move dll files"
)
