cmake_minimum_required(VERSION 3.0)

project(ogre)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/ogre/archive/v1.11.2-f4s.zip)
set(OGRE_HASH 19a9232a868a3359e12c84b81e6d2166c7fde52fe624e265e41ced82b7e6c300)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(OGRE_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DOGRE_BUILD_SAMPLES:BOOL=OFF
                    -DOGRE_INSTALL_SAMPLES:BOOL=OFF
                    -DOGRE_INSTALL_SAMPLES_SOURCE:BOOL=OFF
                    -DOGRE_BUILD_TESTS:BOOL=OFF
                    -DOGRE_BUILD_TOOLS:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GL:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GLES2:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_GL3PLUS:BOOL=ON
                    -DOGRE_BUILD_RENDERSYSTEM_D3D9:BOOL=OFF
                    -DOGRE_BUILD_RENDERSYSTEM_D3D11:BOOL=OFF
                    -DOGRE_INSTALL_DOCS:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_BSP:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_CG:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_FREEIMAGE:BOOL=ON
                    -DOGRE_BUILD_PLUGIN_OCTREE:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_PCZ:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_PFX:BOOL=OFF
                    -DOGRE_BUILD_PLUGIN_STBI:BOOL=OFF
                    -DOGRE_BUILD_DEPENDENCIES:BOOL=OFF
                    -DOGRE_INSTALL_DEPENDENCIES:BOOL=OFF
                    -DOGRE_CONFIG_ENABLE_ZIP:BOOL=ON
                    -DOGRE_BUILD_PLATFORM_APPLE_IOS:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_HLMS:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_TERRAIN:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_VOLUME:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_BITES:BOOL=OFF
                    -DOGRE_BUILD_COMPONENT_PYTHON:BOOL=OFF
                    -DOGRE_CONFIG_THREAD_PROVIDER:STRING=std
                    -DOGRE_BUILD_LIBS_AS_FRAMEWORKS=OFF # No, we don't want framework, even on macOS
                    -DOGRE_RESOURCEMANAGER_STRICT=0 # Use the (slow) legacy mode otherwise our apps break
   )

set(OGRE_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

if(APPLE)
    list(APPEND OGRE_PATCH_CMD COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${OGRE_PATCH_DIR}/macos_paths.diff -d <SOURCE_DIR>)
    list(APPEND OGRE_PATCH_CMD COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${OGRE_PATCH_DIR}/macos_ninja.diff -d <SOURCE_DIR>)
endif()

if(WIN32)
    set(OGRE_CMAKE_ARGS ${OGRE_CMAKE_ARGS} -DOGRE_INSTALL_PDB:BOOL=OFF)
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
    DOWNLOAD_NAME ogre-1.11.2-f4s.zip
    DEPENDS ${OGRE_DEPENDS}
    PATCH_COMMAND ${OGRE_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${OGRE_CMAKE_ARGS}
)

