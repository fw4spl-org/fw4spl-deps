cmake_minimum_required(VERSION 3.0)

project(ogre)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/ogre/archive/fix-cocoa-window-size-getter.zip)
set(OGRE_HASH 53ac5af84568e76f374c4337e6ddfb68d6bb1fc93b36164f6120f1f978a0813d)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(OGRE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DOGRE_BUILD_SAMPLES:BOOL=OFF
                    -DOGRE_INSTALL_SAMPLES:BOOL=OFF
                    -DOGRE_INSTALL_SAMPLES_SOURCE:BOOL=OFF
                    -DOGRE_BUILD_TESTS:BOOL=OFF
                    -DOGRE_BUILD_TOOLS:BOOL=OFF
                    -DOGRE_INSTALL_TOOLS:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GL:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GLES2:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GL3PLUS:BOOL=ON
                    -DOGRE_BUILD_RENDERSYSTEM_D3D9:BOOL=OFF
                    -DOGRE_INSTALL_DOCS:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_CG:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_PCZ:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_PFX:BOOL=OFF
                    -DOGRE_BUILD_DEPENDENCIES:BOOL=OFF
                    -DOGRE_INSTALL_DEPENDENCIES:BOOL=OFF
                    -DOGRE_CONFIG_ENABLE_ZIP:BOOL=ON
                    -DOGRE_CONFIG_ENABLE_FREEIMAGE:BOOL=ON
                    -DOGRE_BUILD_PLATFORM_APPLE_IOS:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_HLMS:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_TERRAIN:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_VOLUME:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_BITES:BOOL=OFF
                    -DOGRE_USE_STD11:BOOL=ON
                    -DOGRE_CONFIG_THREAD_PROVIDER:STRING=std
                    -DOGRE_BUILD_LIBS_AS_FRAMEWORKS=OFF # No, we don't want framework, even on macOS
                    -DOGRE_NODE_STORAGE_LEGACY=OFF
   )

set(OGRE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

if(APPLE)
    list(APPEND OGRE_PATCH_CMD COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${OGRE_PATCH_DIR}/macos_paths.diff -d <SOURCE_DIR>)
    list(APPEND OGRE_PATCH_CMD COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${OGRE_PATCH_DIR}/macos_libc++.diff -d <SOURCE_DIR>)
    list(APPEND OGRE_PATCH_CMD COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${OGRE_PATCH_DIR}/macos_ninja.diff -d <SOURCE_DIR>)
endif()

if(WIN32)
    set(OGRE_CMAKE_ARGS ${OGRE_CMAKE_ARGS} -DOGRE_INSTALL_PDB:BOOL=OFF)
    list(APPEND OGRE_PATCH_CMD COMMAND ${CMAKE_COMMAND} -E copy_if_different "${OGRE_PATCH_DIR}/PrecompiledHeader.cmake" "<SOURCE_DIR>/CMake/Utils/PrecompiledHeader.cmake")
endif()

set(OGRE_DEPENDS zzip freeimage)
if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    list(APPEND OGRE_DEPENDS freetype boost)
endif()

ExternalProject_Add(
    ogre
    URL ${CACHED_URL}
    URL_HASH SHA256=${OGRE_HASH}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME ogre-1.10.11+fix-layout-location-parsing-with-interpolation.zip
    DEPENDS ${OGRE_DEPENDS}
    PATCH_COMMAND ${OGRE_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${OGRE_CMAKE_ARGS}
)

