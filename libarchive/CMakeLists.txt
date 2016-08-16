cmake_minimum_required(VERSION 3.0)

project(libarchiveBuilder)

include(ExternalProject)

set(LIBARCHIVE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                          -DENABLE_TEST:BOOL=OFF
)

set(CACHED_URL http://www.libarchive.org/downloads/libarchive-3.1.2.zip)

set(PATCH_CMD "")

if(ANDROID)
    set(PATCH_CMD ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/archive_read_disk_posix.c "<SOURCE_DIR>/libarchive/archive_read_disk_posix.c"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/CMakeLists.txt "<SOURCE_DIR>/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/util.c "<SOURCE_DIR>/tar/util.c" 
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/patch/libarchive/CMakeLists.txt "<SOURCE_DIR>/libarchive/CMakeLists.txt")

endif()

if(UNIX)
    list(APPEND LIBARCHIVE_CMAKE_ARGS -DENABLE_ICONV:BOOL=OFF -DENABLE_EXPAT:BOOL=ON)
    set(LIBARCHIVE_DEPENDS zlib expat libxml)
elseif(WIN32)
    list(APPEND LIBARCHIVE_CMAKE_ARGS -DENABLE_ICONV:BOOL=ON 
                                      -DENABLE_EXPAT:BOOL=OFF
                                      -DCMAKE_C_FLAGS_DEBUG:STRING=/W2
    )
    set(LIBARCHIVE_DEPENDS zlib libiconv libxml)
endif()


ExternalProject_Add(
    libarchive
    URL ${CACHED_URL}
    URL_HASH SHA256=2e14b48e520524317927baf991998e01bb2ecd6bd181cda34e41bfc8b010acfb
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS ${LIBARCHIVE_DEPENDS}
    PATCH_COMMAND ${PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${LIBARCHIVE_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)
if(WIN32)
    ExternalProject_Add_Step(libarchive ZlibCopy
        COMMAND ${CMAKE_COMMAND} -E copy 
                ${CMAKE_INSTALL_PREFIX}/bin/${ZLIB_LIB_NAME}.dll 
                ${CMAKE_CURRENT_BINARY_DIR}/libarchive-prefix/src/libarchive-build/${ZLIB_LIB_NAME}.dll
        DEPENDEES download 
        COMMENT "Copy ZLib"
    )
endif()

ExternalProject_Add_Step(libarchive CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/fw-libarchive.cmake ${CMAKE_INSTALL_PREFIX}/fw-libarchive.cmake
    COMMENT "Install configuration file")
