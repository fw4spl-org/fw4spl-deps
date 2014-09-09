cmake_minimum_required(VERSION 2.8)

project(json-spiritBuilder)

include(ExternalProject)

set(JSON-SPIRIT_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                    -DBUILD_DOXYGEN:BOOL=OFF
                    #-DBoost_DEBUG=OFF
                    -DBoost_NO_SYSTEM_PATHS=ON
                    -DBoost_USE_DEBUG_PYTHON=ON
                    -DBoost_USE_MULTITHREADED=ON
)

getCachedUrl(https://gitorious.org/json-spirit/yekms-json-spirit/archive/02bf2cc4d476af28a7cf84b5d29ba264c1ca0bab.tar.gz CACHED_URL)

set(JSON_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
ExternalProject_Add(
    json-spirit
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${JSON_PATCH_DIR}/CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt" 
    DEPENDS boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${JSON-SPIRIT_CMAKE_ARGS}

    )


